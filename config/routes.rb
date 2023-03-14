Rails.application.routes.draw do
  root "home#index"
  resources :notes
  resources :users, only: [:show, :new, :create]
  resources :sessions, only: [:new, :create, :edit, :destroy]
  resources :account_activations, only: :edit
  resources :password_resets, only: [:new, :create, :edit, :update]

  get 'logout' => 'sessions#destroy'
  get 'signup' => 'users#new'
  get 'login' => 'sessions#new'
end
