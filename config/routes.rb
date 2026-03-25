# frozen_string_literal: true

Rails.application.routes.draw do
  mount_avo
  devise_for :users, controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations',
    passwords: 'users/passwords',
    confirmations: 'users/confirmations'
  }
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get 'up' => 'rails/health#show', as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  # root "posts#index"

  root 'home#show'

  resource :home, only: [:show], controller: 'home' do
    get :top_games
    get :next_events
    get :top_profiles
  end

  namespace :account do
    resources :profiles, only: %i[index show] do
      resources :games, only: %i[index]
      resources :schedules, only: %i[index] do
        get :calendar, on: :collection
      end
    end
    resource :profile, only: %i[] do
      get :me, on: :collection
      match :update_base, via: [:post, :patch]
      patch :update_email

      resources :games, only: %i[new create destroy], as: :my_games
      resources :schedules, except: %i[index], as: :my_schedules
    end
  end

  get 'search_modal', to: 'games#search_modal'
  get 'game/:id', to: 'games#show', as: :game
end
