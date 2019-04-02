Rails.application.routes.draw do
  root 'welcome#index'
  get 'errors/not_found'
  get 'errors/internal_server_error'

  devise_for :users

  resources :authors,         only: [:index, :show]
  resources :contacts,        only: [:index]
  resources :genres,          only: [:index, :show]
  resources :lists,           only: [:index, :show]
  resources :extended_search, only: [:new, :show]
  resources :search,          only: [:index]
  resources :quotes,          only: [:index, :show]
  resources :articles,        only: [:index, :show]
  resources :tags,            only: [:index, :show]
  resources :formats,         only: [:index, :show]
  resources :books,           only: [:show] do
    collection do
      get :autocomplete_with_seo
    end
  end

  namespace :api, defaults: { format: :json } do
    resources :search,   only: [:index]
    get       :paper,    to: 'search#paper'
    get       'recomendations/paper' => 'recomendations#paper'
  end

  namespace :admin do
    root to: 'admin#index'

    resources :articles
    resources :lists
    resources :books
    resources :quotes
  end

  match '/404', to: 'errors#not_found', via: :all
  match '/500', to: 'errors#internal_server_error', via: :all
end
