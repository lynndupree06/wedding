Rails.application.routes.draw do
  devise_for :users #, :path_names => { :sign_up => "register" }
  resources :parties

  resources :groups

  resources :guests

  root 'home#index'

  get '/our_story' => 'home#our_story'
  get '/wedding' => 'home#wedding'
  get '/reception' => 'home#reception'
  get '/rsvp' => 'rsvp#index'
  get '/registry' => 'home#registry'
  get '/wedding_party' => 'home#wedding_party'
  get '/guest_info' => 'home#guest_info'

  get '/rsvp/search' => 'rsvp#search'

  get '/save-the-date-a' => 'parties#save_the_date_a'
  get '/save-the-date-b' => 'parties#save_the_date_b'
  get '/save-the-date-special' => 'parties#save_the_date_special'
  get '/address_update' => 'parties#user_update'

  resources :users
  resources :photos

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
