# frozen_string_literal: true

# == Schema Information
#
# Table name: account_profiles
#
#  id         :bigint           not null, primary key
#  name       :string(255)      not null
#  rating     :float
#  slug       :string
#  timezone   :string(255)      default("UTC"), not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :integer          not null
#
# Indexes
#
#  index_account_profiles_on_slug     (slug) UNIQUE
#  index_account_profiles_on_user_id  (user_id)
#
module Account
  class Profile < ApplicationRecord
    extend FriendlyId

    attr_accessor :remove_avatar

    friendly_id :name, use: %i[slugged history finders], slug_limit: 40

    belongs_to :user
    has_many :external_ids, as: :owner, dependent: :destroy
    has_many :stores, through: :external_ids
    has_many :account_games, class_name: 'Account::Game', inverse_of: :account_profile
    has_many :games, through: :account_games, source: :game, class_name: '::Game'
    has_many :languages, class_name: 'Account::PrefferedLanguage',
                         inverse_of: :account_profile,
                         dependent: :destroy
    has_many :outgoing_requests, class_name: 'Account::FriendRequest',
                                 inverse_of: :requester,
                                 dependent: :destroy
    has_many :incoming_requests, class_name: 'Account::FriendRequest',
                                 foreign_key: 'recipient_id',
                                 inverse_of: :recipient,
                                 dependent: :destroy
    has_many :outgoing_blacklist, class_name: 'Account::BlackList',
                                  inverse_of: :requester,
                                  dependent: :destroy
    has_many :incoming_blacklist, class_name: 'Account::BlackList',
                                  inverse_of: :target,
                                  dependent: :destroy
    has_many :blacklisted, through: :outgoing_blacklist, source: :target
    has_many :blacklisted_by, through: :incoming_blacklist, source: :requester
    has_many :schedules, as: :owner, dependent: :destroy
    has_many :event_profiles, class_name: 'Social::EventProfile',
                              inverse_of: :account_profile,
                              dependent: :destroy
    has_many :social_events, through: :event_profiles, source: :social_event

    has_one_attached :avatar do |attachable|
      attachable.variant :small, resize_to_fill: [36, 36]
      attachable.variant :medium, resize_to_fill: [128, 128]
    end

    validates :time_zone, inclusion: { in: ActiveSupport::TimeZone.all.map(&:name) }, allow_blank: true

    accepts_nested_attributes_for :user, update_only: true
    before_save :purge_avatar_if_needed

    def friends
      sent_ids = outgoing_requests.accepted.select(:recipient_id)
      received_ids = incoming_requests.accepted.select(:requester_id)

      Account::Profile.where(id: sent_ids).or(Account::Profile.where(id: received_ids))
    end

    def blocked_by?(account_profile)
      blacklisted_by.exists?(account_profile.id)
    end

    private

    def purge_avatar_if_needed
      avatar.purge if ActiveModel::Type::Boolean.new.cast(remove_avatar)
    end
  end
end
