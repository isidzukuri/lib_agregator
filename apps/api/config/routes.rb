Api::Engine.routes.draw do
    namespace :api, defaults: { format: :json } do
      resources :search,   only: [:index]
      get       :paper,    to: 'search#paper'
      get       'recomendations/paper'
    end
end
