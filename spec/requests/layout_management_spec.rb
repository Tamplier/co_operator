# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Layout management', type: :request do
  describe 'GET /' do
    subject { get '/' }

    before(:example) do
      sign_in user if user.present?
      subject
    end

    context 'when user is not registered' do
      let(:user) { nil }

      it "doesn't contain user specific header and sidebar" do
        aggregate_failures do
          expect(response.body).not_to include('id="menuToggle"')
          expect(response.body).not_to include('id="notifications"')
          expect(response.body).not_to include('id="settings"')
          expect(response.body).not_to include('id="logout"')
          expect(response.body).not_to include('id="sidebar_container"')
          expect(response.body).to include('id="login"')
        end
      end
    end

    context 'when user is registered' do
      let(:user) { create(:user, :with_profile) }

      it 'contains user specific header and sidebar' do
        aggregate_failures do
          expect(response.body).to include('id="menuToggle"')
            .and include('id="notifications"')
            .and include('id="settings"')
            .and include('id="logout"')
            .and include('id="sidebar_container"')
          expect(response.body).not_to include('id="login"')
        end
      end
    end
  end
end
