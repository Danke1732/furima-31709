Rails.application.routes.draw do
  root to: 'items#index'
  devise_for :users, controllers: {
    registrations: "users/registrations",
  }
  resources :items do
    resources :transactions, only: [:index, :create]
  end
  resources :users, only: :show
end
