Rails.application.routes.draw do
  root to: 'elements#index'

  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  get '/logout', to: 'sessions#destroy'
  get '/auth/:provider/callback', to: 'sessions#create'

  get '/signup', to: 'users#new'
  resources :users, only: [:create, :show, :edit, :update]

  resources :elements, only: [:index, :show, :edit, :update] do
    resources :ropes, only: [:new, :create, :update]
    resources :preuse_inspections, only: [:index, :create, :edit, :update]
    resources :periodic_inspections, only: [:new, :create, :show, :edit, :update]
  end

  resources :periodic_inspections
  resources :comments, only: [:index, :show]
end
