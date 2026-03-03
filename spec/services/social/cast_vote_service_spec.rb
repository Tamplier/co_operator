# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Social::CastVoteService, type: :service do
  subject { described_class.call(request, user, new_decision) }

  let(:decision) { 'positive' }
  let(:new_decision) { decision }
  let(:social_event) { create(:social_event, :with_users, max_players: 5, users_count: 4) }
  let(:request_trait) { %i[in_review kick_request] }
  let(:request) do
    create(:social_request, *request_trait, decision: decision, social_event: social_event)
  end

  context 'when user is not authorized' do
    let(:user) { create(:user) }

    it "doesn't allow to vote" do
      result = subject

      aggregate_failures 'result checks' do
        expect(result).not_to be_success
        expect(result.error).to include('not authorized')
      end
    end
  end

  context 'when user is authorized' do
    let(:user) do
      social_event.profiles
                  .where.not(id: request.target_profile_id)
                  .where.not(id: request.votes.select(:account_profile_id))
                  .first.user
    end

    %i[accepted rejected].each do |request_status|
      context "when request is #{request_status}" do
        let(:request_trait) { [request_status, :kick_request] }

        it "doesn't change anything" do
          expect { @result = subject }.not_to(change { request.status })

          aggregate_failures 'result checks' do
            expect(@result).not_to be_success
            expect(@result.error).to include('finalized')
          end
        end
      end
    end

    context 'when not not enough votes' do
      it 'creates new vote object' do
        expect { @result = subject }
          .to change { request.votes.count }.by(1)
          .and not_change { request.reload.status }.from('in_review')

        aggregate_failures 'check result' do
          expect(@result).to be_success
          expect(@result.result).to have_attributes(
            decision: decision,
            social_request: request,
            account_profile: user.account_profile
          )
        end
      end
    end

    context 'when there are enough votes to close request' do
      let(:request_trait) { %i[in_review kick_request one_vote_away_from_closing] }

      context 'when user has already voted' do
        let(:vote) { request.votes.last }
        let(:user) { vote.account_profile.user }
        let(:new_decision) { 'negative' }

        it 'changes the vote decision' do
          expect { subject }
            .to change { vote.reload.decision }.from(decision).to(new_decision)
            .and not_change { request.reload.status }.from('in_review')
            .and(not_change { request.votes.count })
        end
      end

      context 'when proposal accepted' do
        let(:decision) { 'positive' }

        it 'finalizes request with accepted status' do
          expect { subject }
            .to change { request.votes.count }.by(1)
            .and change { request.reload.status }.from('in_review').to('accepted')
        end
      end

      context 'when proposad rejected' do
        let(:decision) { 'negative' }

        it 'finalizes request with rejected status' do
          expect { subject }
            .to change { request.votes.count }.by(1)
            .and change { request.reload.status }.from('in_review').to('rejected')
        end
      end
    end
  end
end
