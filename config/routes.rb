Rails.application.routes.draw do
  resources :territories, only: [:index]
end
