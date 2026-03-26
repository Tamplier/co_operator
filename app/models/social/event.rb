# frozen_string_literal: true

# == Schema Information
#
# Table name: social_events
#
#  id          :bigint           not null, primary key
#  duration    :integer          not null
#  max_players :integer
#  name        :string
#  start_date  :datetime
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  game_id     :integer          not null
#  language_id :integer          not null
#
# Indexes
#
#  index_social_events_on_game_id      (game_id)
#  index_social_events_on_language_id  (language_id)
#
# Foreign Keys
#
#  fk_rails_...  (game_id => games.id)
#  fk_rails_...  (language_id => languages.id)
#
module Social
  class Event < ApplicationRecord
    belongs_to :language
    belongs_to :game

    has_many :event_profiles, class_name: 'Social::EventProfile',
                              inverse_of: 'social_event',
                              dependent: :destroy
    has_many :profiles, through: :event_profiles, source: :account_profile

    validates :max_players, numericality: { greater_than: 0 }
  end
end
