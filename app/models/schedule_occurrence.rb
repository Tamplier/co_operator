# frozen_string_literal: true

# == Schema Information
#
# Table name: schedule_occurrences
#
#  id          :bigint           not null, primary key
#  end_at      :datetime         not null
#  start_at    :datetime         not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  schedule_id :integer          not null
#
# Indexes
#
#  index_schedule_occurrences_on_schedule_id               (schedule_id)
#  index_schedule_occurrences_on_schedule_id_and_start_at  (schedule_id,start_at) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (schedule_id => schedules.id)
#
class ScheduleOccurrence < ApplicationRecord
  belongs_to :schedule

  validates :start_at, comparison: { less_than: :end_at }
end
