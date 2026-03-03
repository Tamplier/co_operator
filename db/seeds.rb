# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

User.find_or_create_by!(email: 'araman777@gmail.com') do |user|
  user.password = 'qwerty'
  user.role = User.roles[:admin]
  user.confirmed_at = Time.now
  user.create_account_profile!(name: 'Alex')
end

I18nData.languages(:en).each do |code, name|
  Language.find_or_create_by!(code: code) { |l| l.name = name }
end
