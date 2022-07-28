# frozen_string_literal: true

Rails.application.routes.draw do
  root to: 'home#index'

  if Rails.env.development?
    get '/dev/login', to: 'development#login'
  end

  get 'phones/random', to: 'phones#random_show', as: :random_phone

  get 'history', to: 'call_attempts#call_history', as: :call_history

  resources :territories do
    resources :phones do
      member do
        get :vcard
      end
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
