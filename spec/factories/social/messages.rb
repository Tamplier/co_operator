# frozen_string_literal: true

# == Schema Information
#
# Table name: social_messages
#
#  id             :integer          not null, primary key
#  recipient_type :string           not null
#  text           :string(2048)
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  author_id      :integer          not null
#  recipient_id   :integer          not null
#
# Indexes
#
#  index_social_messages_on_author_id  (author_id)
#  index_social_messages_on_recipient  (recipient_type,recipient_id)
#
# Foreign Keys
#
#  author_id  (author_id => account_profiles.id)
#
FactoryBot.define do
  factory :social_message, class: 'Social::Message' do
    author { nil }
    recipient { nil }
    text { 'MyString' }
  end
end
