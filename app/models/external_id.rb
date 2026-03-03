# frozen_string_literal: true

# == Schema Information
#
# Table name: external_ids
#
#  id          :bigint           not null, primary key
#  owner_type  :string           not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  external_id :string(255)      not null
#  owner_id    :integer          not null
#  store_id    :integer          not null
#
# Indexes
#
#  index_external_ids_on_owner                                 (owner_type,owner_id)
#  index_external_ids_on_owner_id_and_owner_type_and_store_id  (owner_id,owner_type,store_id) UNIQUE
#  index_external_ids_on_store_id                              (store_id)
#
# Foreign Keys
#
#  fk_rails_...  (store_id => stores.id)
#
class ExternalId < ApplicationRecord
  belongs_to :store
  belongs_to :owner, polymorphic: true

  validates :external_id, presence: true
  validates :owner_id, uniqueness: { scope: %i[store_id owner_type] }
end
