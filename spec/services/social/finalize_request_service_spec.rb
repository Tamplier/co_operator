# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Social::FinalizeRequestService, type: :service do
  subject { described_class.call(request) }

  let(:request) { create(:social_request, *request_traits) }
  let(:event) { request.social_event }
  let(:target_profile) { request.target_profile }

  %i[in_review rejected].each do |status|
    %i[kick_request join_request].each do |request_type|
      context "when #{request_type} is #{status}" do
        let(:request_traits) { [status, request_type] }

        it 'does nothing' do
          expect { subject }
            .to not_change(request, :status).from(status.to_s)
            .and(not_change { event.reload.profiles.count })
        end
      end
    end
  end

  context 'when request is accepted' do
    context 'when kick request' do
      let(:request_traits) { %i[accepted kick_request] }

      it 'kicks user from event' do
        expect { @result = subject }
          .to change { event.reload.profiles.count }.by(-1)
          .and change { event.profiles.include?(target_profile) }.from(true).to(false)

        expect(@result).to be_success
      end
    end

    context 'when join request' do
      let(:request_traits) { %i[accepted join_request] }

      it 'joins user to event' do
        expect { @result = subject }
          .to change { event.reload.profiles.count }.by(1)
          .and change { event.profiles.include?(target_profile) }.from(false).to(true)

        expect(@result).to be_success
      end
    end
  end
end
