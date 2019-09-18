Api::Engine.routes.draw do
  constraints format: :json do
      resources :search,   only: [:index]
      get       :paper,    to: 'search#paper'
      get       'recomendations/paper'
  end
end
