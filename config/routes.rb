# frozen_string_literal: true

Rails.application.routes.draw do
  root to: 'home#index'

  if Rails.env.development?
    get '/dev/login', to: 'development#login'
  end

  resources :territories do
    resources :phones do
      collection do
        get :vcards
      end
      resources :call_attempts do
        collection do
          post 'create/:outcome', as: :create, action: :quick_create
        end
      end
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
