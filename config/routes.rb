Rails.application.routes.draw do

  devise_for :admins
  root 'event_dashboards#show'
  get  'events/actors'    => 'events#actors',    as: :actors
  get  'events/countries' => 'events#countries', as: :countries
  get  'events/upload'    => 'events#upload',    as: :upload
  post 'events/upload'    => 'events#import',    as: :import
  get  'events/admin'     => 'events#admin',     as: :admin_dashboard

  resources :events
  get 'events/countries/:country' => 'events#by_country', as: :country
  get 'events/actors/:actor'      => 'events#by_actor', as: :actor

  get 'dashboards/countries/:country' => 'country_dashboards#show'

  namespace :api do
    namespace :v1 do
      resources :events
      post 'events/:id/approve' => 'events#approve', as: :approve
      post 'events/:id/deny' => 'events#destroy', as: :deny
    end
  end

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
