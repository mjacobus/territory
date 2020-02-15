# frozen_string_literal: true

Rails.application.routes.draw do
  root to: 'home#index'

  resources :territories, except: %i[destroy edit update show]
  resources :users, only: %i[index]

  get '/auth/:provider/callback', to: 'sessions#create'
  get 'logout', to: 'sessions#destroy'
end
