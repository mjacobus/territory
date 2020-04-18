# frozen_string_literal: true

Rails.application.routes.draw do
  root to: 'home#index'

  resources :territories do
    resources :phones do
      resources :call_attempts
    end
  end

  resources :users, only: %i[index] do
    member do
      patch :enable
      patch :disable
      patch :grant_admin
      patch :revoke_admin
    end
  end

  get '/auth/:provider/callback', to: 'sessions#create'
  get 'logout', to: 'sessions#destroy'
end
