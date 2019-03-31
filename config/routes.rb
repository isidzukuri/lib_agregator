Rails.application.routes.draw do
  root 'welcome#index'
  get 'errors/not_found'
  get 'errors/internal_server_error'

  devise_for :users

  resources :authors,         only: [:index, :show]
  resources :books,           only: [:show]
  resources :contacts,        only: [:index]
  resources :genres,          only: [:index, :show]
  resources :lists,           only: [:index, :show]
  resources :extended_search, only: [:new, :show]
  resources :search,          only: [:index]
  resources :quotes,          only: [:index, :show]

  get 'articles/' => 'articles#index'
  get 'articles/:key' => 'articles#show'

  get 'tags/' => 'tags#index'
  get 'tags/:key' => 'tags#show'

  get 'formats/' => 'formats#index'
  get 'formats/:key' => 'formats#show'

  get 'books/autocomplete_with_seo' => 'books#autocomplete_with_seo'

  namespace :api, defaults: { format: 'json' } do
    get 'search' => 'search#index'
    get 'paper' => 'search#paper'
    get 'recomendations/paper' => 'recomendations#paper'
  end

  namespace :admin do
    get '/' => 'admin#index'
    resources :articles
    resources :lists
    resources :books
    resources :quotes
  end

  match '/404', to: 'errors#not_found', via: :all
  match '/500', to: 'errors#internal_server_error', via: :all
end
