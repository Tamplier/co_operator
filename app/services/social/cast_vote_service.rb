# frozen_string_literal: true

module Social
  class CastVoteService < ApplicationService
    attr_reader :current_user, :request, :decision

    def initialize(request, user, decision)
      super()
      @request = request
      @current_user = user
      @decision = decision
    end

    def call
      authorize request, :vote?
      raise InvalidStateError, 'Request already finalized' unless request.in_review?

      vote = create_or_update_vote!
      try_to_finalize_request!

      success(vote)
    end

    private

    def create_or_update_vote!
      profile = current_user.account_profile
      vote = request.votes.find_or_initialize_by(account_profile: profile)
      vote.update!(decision: decision)
      vote
    end

    def try_to_finalize_request!
      stat = request.votes_stat
      vote_threshold = (stat[:max_votes] / 2.0).floor + 1
      if stat[:positive_votes] > vote_threshold
        request.accepted!
        Social::FinalizeRequestService.call!(request)
      elsif stat[:negative_votes] > vote_threshold
        request.rejected!
      end
    end
  end
end
