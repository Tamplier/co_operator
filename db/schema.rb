# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.1].define(version: 20_260_224_110_838) do
  # These are extensions that must be enabled in order to support this database
  enable_extension 'pg_catalog.plpgsql'

  create_table 'account_black_lists', force: :cascade do |t|
    t.datetime 'created_at', null: false
    t.integer 'requester_id', null: false
    t.integer 'target_id', null: false
    t.datetime 'updated_at', null: false
    t.index %w[requester_id target_id], name: 'index_account_black_lists_on_requester_id_and_target_id', unique: true
    t.index ['requester_id'], name: 'index_account_black_lists_on_requester_id'
    t.index ['target_id'], name: 'index_account_black_lists_on_target_id'
  end

  create_table 'account_friend_requests', force: :cascade do |t|
    t.datetime 'created_at', null: false
    t.integer 'recipient_id', null: false
    t.integer 'requester_id', null: false
    t.integer 'status', default: 0, null: false
    t.datetime 'updated_at', null: false
    t.index ['recipient_id'], name: 'index_account_friend_requests_on_recipient_id'
    t.index %w[requester_id recipient_id], name: 'index_account_friend_requests_on_requester_id_and_recipient_id',
                                           unique: true, where: '(status <> 1)'
    t.index ['requester_id'], name: 'index_account_friend_requests_on_requester_id'
  end

  create_table 'account_preffered_languages', force: :cascade do |t|
    t.integer 'account_profile_id', null: false
    t.datetime 'created_at', null: false
    t.integer 'language_id', null: false
    t.integer 'priority', null: false
    t.datetime 'updated_at', null: false
    t.index %w[account_profile_id language_id], name: 'idx_on_account_profile_id_language_id_09a4578ee7',
                                                unique: true
    t.index ['account_profile_id'], name: 'index_account_preffered_languages_on_account_profile_id'
    t.index ['language_id'], name: 'index_account_preffered_languages_on_language_id'
  end

  create_table 'account_profiles', force: :cascade do |t|
    t.datetime 'created_at', null: false
    t.string 'name', limit: 255, null: false
    t.float 'rating'
    t.string 'slug'
    t.string 'timezone', limit: 255, default: 'UTC', null: false
    t.datetime 'updated_at', null: false
    t.integer 'user_id', null: false
    t.index ['slug'], name: 'index_account_profiles_on_slug', unique: true
    t.index ['user_id'], name: 'index_account_profiles_on_user_id'
  end

  create_table 'account_scheduled_games', force: :cascade do |t|
    t.datetime 'created_at', null: false
    t.integer 'game_id', null: false
    t.integer 'schedule_id', null: false
    t.datetime 'updated_at', null: false
    t.index ['game_id'], name: 'index_account_scheduled_games_on_game_id'
    t.index %w[schedule_id game_id], name: 'index_account_scheduled_games_on_schedule_id_and_game_id', unique: true
    t.index ['schedule_id'], name: 'index_account_scheduled_games_on_schedule_id'
  end

  create_table 'active_storage_attachments', force: :cascade do |t|
    t.bigint 'blob_id', null: false
    t.datetime 'created_at', null: false
    t.string 'name', null: false
    t.bigint 'record_id', null: false
    t.string 'record_type', null: false
    t.index ['blob_id'], name: 'index_active_storage_attachments_on_blob_id'
    t.index %w[record_type record_id name blob_id], name: 'index_active_storage_attachments_uniqueness',
                                                    unique: true
  end

  create_table 'active_storage_blobs', force: :cascade do |t|
    t.bigint 'byte_size', null: false
    t.string 'checksum'
    t.string 'content_type'
    t.datetime 'created_at', null: false
    t.string 'filename', null: false
    t.string 'key', null: false
    t.text 'metadata'
    t.string 'service_name', null: false
    t.index ['key'], name: 'index_active_storage_blobs_on_key', unique: true
  end

  create_table 'active_storage_variant_records', force: :cascade do |t|
    t.bigint 'blob_id', null: false
    t.string 'variation_digest', null: false
    t.index %w[blob_id variation_digest], name: 'index_active_storage_variant_records_uniqueness', unique: true
  end

  create_table 'external_ids', force: :cascade do |t|
    t.datetime 'created_at', null: false
    t.string 'external_id', limit: 255, null: false
    t.integer 'owner_id', null: false
    t.string 'owner_type', null: false
    t.integer 'store_id', null: false
    t.datetime 'updated_at', null: false
    t.index %w[owner_id owner_type store_id], name: 'index_external_ids_on_owner_id_and_owner_type_and_store_id',
                                              unique: true
    t.index %w[owner_type owner_id], name: 'index_external_ids_on_owner'
    t.index ['store_id'], name: 'index_external_ids_on_store_id'
  end

  create_table 'friendly_id_slugs', force: :cascade do |t|
    t.datetime 'created_at'
    t.string 'scope'
    t.string 'slug', null: false
    t.integer 'sluggable_id', null: false
    t.string 'sluggable_type', limit: 50
    t.index %w[slug sluggable_type scope], name: 'index_friendly_id_slugs_on_slug_and_sluggable_type_and_scope',
                                           unique: true
    t.index %w[slug sluggable_type], name: 'index_friendly_id_slugs_on_slug_and_sluggable_type'
    t.index %w[sluggable_type sluggable_id], name: 'index_friendly_id_slugs_on_sluggable_type_and_sluggable_id'
  end

  create_table 'games', force: :cascade do |t|
    t.datetime 'created_at', null: false
    t.string 'description', limit: 300, null: false
    t.float 'rating'
    t.string 'title', limit: 255, null: false
    t.datetime 'updated_at', null: false
  end

  create_table 'languages', force: :cascade do |t|
    t.string 'code', limit: 10, null: false
    t.datetime 'created_at', null: false
    t.string 'name', limit: 255, null: false
    t.datetime 'updated_at', null: false
    t.index ['code'], name: 'index_languages_on_code', unique: true
  end

  create_table 'schedule_occurrences', force: :cascade do |t|
    t.datetime 'created_at', null: false
    t.datetime 'end_at', null: false
    t.integer 'schedule_id', null: false
    t.datetime 'start_at', null: false
    t.datetime 'updated_at', null: false
    t.index %w[schedule_id start_at], name: 'index_schedule_occurrences_on_schedule_id_and_start_at', unique: true
    t.index ['schedule_id'], name: 'index_schedule_occurrences_on_schedule_id'
  end

  create_table 'schedules', force: :cascade do |t|
    t.boolean 'active', null: false
    t.datetime 'created_at', null: false
    t.time 'end_time', null: false
    t.integer 'owner_id', null: false
    t.string 'owner_type', null: false
    t.string 'recurrence_rule', limit: 255
    t.datetime 'reference_date', null: false
    t.time 'start_time', null: false
    t.datetime 'updated_at', null: false
    t.index %w[owner_id owner_type reference_date start_time],
            name: 'idx_on_owner_id_owner_type_reference_date_start_tim_8e339f2eb8', unique: true
    t.index %w[owner_type owner_id], name: 'index_schedules_on_owner'
  end

  create_table 'social_event_profiles', force: :cascade do |t|
    t.integer 'account_profile_id', null: false
    t.datetime 'created_at', null: false
    t.integer 'social_event_id', null: false
    t.datetime 'updated_at', null: false
    t.index ['account_profile_id'], name: 'index_social_event_profiles_on_account_profile_id'
    t.index %w[social_event_id account_profile_id], name: 'idx_on_social_event_id_account_profile_id_e7370d494a',
                                                    unique: true
    t.index ['social_event_id'], name: 'index_social_event_profiles_on_social_event_id'
  end

  create_table 'social_events', force: :cascade do |t|
    t.datetime 'created_at', null: false
    t.integer 'game_id', null: false
    t.integer 'language_id', null: false
    t.integer 'max_players'
    t.string 'name'
    t.datetime 'start_date'
    t.datetime 'updated_at', null: false
    t.index ['game_id'], name: 'index_social_events_on_game_id'
    t.index ['language_id'], name: 'index_social_events_on_language_id'
  end

  create_table 'social_messages', force: :cascade do |t|
    t.integer 'author_id', null: false
    t.datetime 'created_at', null: false
    t.integer 'recipient_id', null: false
    t.string 'recipient_type', null: false
    t.string 'text', limit: 2048
    t.datetime 'updated_at', null: false
    t.index ['author_id'], name: 'index_social_messages_on_author_id'
    t.index %w[recipient_type recipient_id], name: 'index_social_messages_on_recipient'
  end

  create_table 'social_requests', force: :cascade do |t|
    t.datetime 'created_at', null: false
    t.integer 'request_type'
    t.integer 'social_event_id', null: false
    t.integer 'status', default: 0
    t.integer 'target_profile_id', null: false
    t.datetime 'updated_at', null: false
    t.index ['social_event_id'], name: 'index_social_requests_on_social_event_id'
    t.index %w[target_profile_id social_event_id request_type],
            name: 'idx_on_target_profile_id_social_event_id_request_ty_f6ff4f78f1', unique: true, where: '(status <> 1)'
    t.index ['target_profile_id'], name: 'index_social_requests_on_target_profile_id'
  end

  create_table 'social_reviews', force: :cascade do |t|
    t.integer 'author_id', null: false
    t.datetime 'created_at', null: false
    t.integer 'rating', null: false
    t.integer 'target_id', null: false
    t.string 'target_type', null: false
    t.string 'text', limit: 2048
    t.datetime 'updated_at', null: false
    t.index %w[author_id target_id target_type], name: 'idx_on_author_id_target_id_target_type_f114ef90b0',
                                                 unique: true
    t.index ['author_id'], name: 'index_social_reviews_on_author_id'
    t.index %w[target_type target_id], name: 'index_social_reviews_on_target'
  end

  create_table 'social_votes', force: :cascade do |t|
    t.integer 'account_profile_id', null: false
    t.datetime 'created_at', null: false
    t.integer 'decision', null: false
    t.integer 'social_request_id', null: false
    t.datetime 'updated_at', null: false
    t.index ['account_profile_id'], name: 'index_social_votes_on_account_profile_id'
    t.index %w[social_request_id account_profile_id],
            name: 'index_social_votes_on_social_request_id_and_account_profile_id', unique: true
    t.index ['social_request_id'], name: 'index_social_votes_on_social_request_id'
  end

  create_table 'stores', force: :cascade do |t|
    t.datetime 'created_at', null: false
    t.string 'game_link_pattern', limit: 255, null: false
    t.string 'profile_link_pattern', limit: 255, null: false
    t.string 'title', limit: 255, null: false
    t.datetime 'updated_at', null: false
  end

  create_table 'users', force: :cascade do |t|
    t.datetime 'confirmation_sent_at'
    t.string 'confirmation_token'
    t.datetime 'confirmed_at'
    t.datetime 'created_at', null: false
    t.string 'email', default: '', null: false
    t.string 'encrypted_password', default: '', null: false
    t.datetime 'remember_created_at'
    t.datetime 'reset_password_sent_at'
    t.string 'reset_password_token'
    t.integer 'role', default: 0
    t.string 'unconfirmed_email'
    t.datetime 'updated_at', null: false
    t.index ['email'], name: 'index_users_on_email', unique: true
    t.index ['reset_password_token'], name: 'index_users_on_reset_password_token', unique: true
  end

  add_foreign_key 'account_black_lists', 'account_profiles', column: 'requester_id'
  add_foreign_key 'account_black_lists', 'account_profiles', column: 'target_id'
  add_foreign_key 'account_friend_requests', 'account_profiles', column: 'recipient_id'
  add_foreign_key 'account_friend_requests', 'account_profiles', column: 'requester_id'
  add_foreign_key 'account_preffered_languages', 'account_profiles'
  add_foreign_key 'account_preffered_languages', 'languages'
  add_foreign_key 'account_scheduled_games', 'games'
  add_foreign_key 'account_scheduled_games', 'schedules'
  add_foreign_key 'active_storage_attachments', 'active_storage_blobs', column: 'blob_id'
  add_foreign_key 'active_storage_variant_records', 'active_storage_blobs', column: 'blob_id'
  add_foreign_key 'external_ids', 'stores'
  add_foreign_key 'schedule_occurrences', 'schedules'
  add_foreign_key 'social_event_profiles', 'account_profiles'
  add_foreign_key 'social_event_profiles', 'social_events'
  add_foreign_key 'social_events', 'games'
  add_foreign_key 'social_events', 'languages'
  add_foreign_key 'social_messages', 'account_profiles', column: 'author_id'
  add_foreign_key 'social_requests', 'account_profiles', column: 'target_profile_id'
  add_foreign_key 'social_requests', 'social_events'
  add_foreign_key 'social_reviews', 'account_profiles', column: 'author_id'
  add_foreign_key 'social_votes', 'account_profiles'
  add_foreign_key 'social_votes', 'social_requests'
end
