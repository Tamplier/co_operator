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

  root 'games#index'
  namespace :account do
    resources :profiles, only: %i[index show]
    resource :profile, only: %i[] do
      get :me, on: :collection
      patch :update_base
      patch :update_email

      resources :games, only: [] do
        get :find, on: :collection
        post :add, on: :member
        delete :remove, on: :member
      end
    end
  end

  get 'search_modal', to: 'games#search_modal'
  get 'game/:id', to: 'games#show', as: :game
end
