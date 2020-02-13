# frozen_string_literal: true

Rails.application.routes.draw do
  root to: 'territories#index'
  resources :territories, except: %i[destroy edit update show]
  get '/auth/:provider/callback', to: 'sessions#create'
  get 'logout', to: 'sessions#destroy'
end
