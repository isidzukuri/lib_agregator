Rails.application.routes.draw do
  get 'errors/not_found'

  get 'errors/internal_server_error'

  devise_for :users

  root 'welcome#index'

  get 'genres/' => 'genres#index'
  get 'genres/:key' => 'genres#show'

  get 'articles/' => 'articles#index'
  get 'articles/:key' => 'articles#show'

  get 'lists/' => 'lists#index'
  get 'lists/:key' => 'lists#show'

  get 'tags/' => 'tags#index'
  get 'tags/:key' => 'tags#show'

  get 'authors/' => 'authors#index'
  get 'authors/:key' => 'authors#show'

  get 'formats/' => 'formats#index'
  get 'formats/:key' => 'formats#show'

  resources :quotes, only: [:index]
  resources :books, only: [:show]
  get 'books/autocomplete_with_seo' => 'books#autocomplete_with_seo'

  get 'search' => 'search#index'
  get 'extended_search' => 'search#extended_form'
  get 'extended_search_results' => 'search#extended_search_results'
  
  get 'contacts' => 'contacts#index'

  resources :quotes, only: [:index, :show]



  namespace :api, :defaults => { :format => 'json' } do
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

  match "/404", :to => "errors#not_found", :via => :all
  match "/500", :to => "errors#internal_server_error", :via => :all
end
