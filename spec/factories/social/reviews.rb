# frozen_string_literal: true

# == Schema Information
#
# Table name: social_reviews
#
#  id          :bigint           not null, primary key
#  rating      :integer          not null
#  target_type :string           not null
#  text        :string(2048)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  author_id   :integer          not null
#  target_id   :integer          not null
#
# Indexes
#
#  idx_on_author_id_target_id_target_type_f114ef90b0  (author_id,target_id,target_type) UNIQUE
#  index_social_reviews_on_author_id                  (author_id)
#  index_social_reviews_on_target                     (target_type,target_id)
#
# Foreign Keys
#
#  fk_rails_...  (author_id => account_profiles.id)
#
FactoryBot.define do
  factory :social_review, class: 'Social::Review' do
    author { nil }
    target { nil }
    text { 'MyString' }
    rating { 1 }
  end
end
