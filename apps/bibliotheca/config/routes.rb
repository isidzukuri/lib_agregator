Bibliotheca::Engine.routes.draw do
  root 'welcome#index'

  get 'errors/not_found'
  get 'errors/internal_server_error'

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

  match '/404', to: 'errors#not_found', via: :all
  match '/500', to: 'errors#internal_server_error', via: :all
end
