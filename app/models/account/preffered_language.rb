# frozen_string_literal: true

# == Schema Information
#
# Table name: account_preffered_languages
#
#  id                 :bigint           not null, primary key
#  priority           :integer          not null
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  account_profile_id :integer          not null
#  language_id        :integer          not null
#
# Indexes
#
#  idx_on_account_profile_id_language_id_09a4578ee7         (account_profile_id,language_id) UNIQUE
#  index_account_preffered_languages_on_account_profile_id  (account_profile_id)
#  index_account_preffered_languages_on_language_id         (language_id)
#
# Foreign Keys
#
#  fk_rails_...  (account_profile_id => account_profiles.id)
#  fk_rails_...  (language_id => languages.id)
#
module Account
  class PrefferedLanguage < ApplicationRecord
    belongs_to :account_profile, class_name: 'Account::Profile'
    belongs_to :language

    validates :priority, uniqueness: { scope: :account_profile_id }
  end
end
