Rails.application.routes.draw do
  devise_for :users
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  get "up" => "rails/health#show", as: :rails_health_check
  root to: 'homes#top'
  get 'contact', to: 'homes#contact', as: :contact
  post 'contact', to: 'homes#contact_submit'

  resources :posts do
    resources :comments, only: [:create, :destroy]
    resource :favorites, only: [:create, :destroy]
    collection do
      get 'confirm'
      get 'my_posts'
    end
  end

  resources :users, only: [:index, :show, :edit, :update] do
    member do
      get :follows, :followers
    end
    resource :relationships, only: [:create, :destroy]
    resources :weights, only: [:create, :destroy]
  end

  get 'stories', to: 'stories#index', as: :stories
  get 'stories/:slug', to: 'stories#show', as: :story
end
