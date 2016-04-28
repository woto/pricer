Rails.application.routes.draw do

  resources :suppliers
  resources :prices do
    member do
      get :list
      post :cleanup
      scope :format => true, :constraints => { :format => 'txt' } do
        get :cheap
      end
      scope :format => true, :constraints => { :format => 'json' } do
        get :download
      end
    end
  end

  resources :uploads do
    member do
      post :recode
      get :head
      get :preview
      post :import, to: "imports#create"
    end
  end

  resource :s, as: :search, controller: "search"
  get "/s/:catalog_number", controller: :search, action: :show, as: :catalog_number_search
	get "/u", controller: :prices, action: :landing

  match "/websocket", :to => ActionCable.server, via: [:get, :post]

  # old route
  get '/user/products/new', to: "search#show"

	root 'welcome#index'

  require 'sidekiq/web'
  mount Sidekiq::Web => '/sidekiq'
  
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

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
