# frozen_string_literal: true

Rails.application.routes.draw do
  resources :territories, except: %i[destroy edit update show]
end
