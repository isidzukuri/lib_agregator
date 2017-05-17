Rails.application.routes.draw do
  devise_for :users
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

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

  get 'books/autocomplete_with_seo' => 'books#autocomplete_with_seo'
  get 'books/:key' => 'books#show'

  get 'search' => 'search#index'
  get 'extended_search' => 'search#extended_form'
  get 'extended_search_results' => 'search#extended_search_results'

  
  get 'contacts' => 'contacts#index'


  namespace :api, :defaults => { :format => 'json' } do
    get 'search' => 'search#index'
     # namespace :v1 do
     #    resources :productOp, :path => "product", 
     # end
  end

  namespace :admin do
    get '/' => 'admin#index'
    resources :articles
    resources :lists
    resources :books
  end

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
