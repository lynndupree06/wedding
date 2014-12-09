Rails.application.routes.draw do
  resources :tables

  devise_for :users, :skip => :registrations

  resources :parties
  resources :groups
  resources :guests
  resources :users

  get '/save-the-date-a' => 'parties#save_the_date_a'
  get '/save-the-date-b' => 'parties#save_the_date_b'
  get '/save-the-date-special' => 'parties#save_the_date_special'
  get '/outer_labels' => 'parties#create_outer_labels'
  get '/place_cards' => 'parties#create_place_card_labels'
  get '/seating_chart' => 'parties#get_seating_chart_data'
  get '/tags' => 'parties#tags'
  get '/parties_info' => 'parties#parties_info'

  root 'home#index'

  get '/our_story' => 'home#our_story'
  get '/wedding' => 'home#wedding'
  get '/reception' => 'home#reception'
  get '/registry' => 'home#registry'
  get '/wedding_party' => 'home#wedding_party'
  get '/guest_info' => 'home#guest_info'
  get '/rsvp' => 'home#rsvp'
  get '/pictures' => 'home#photos'

  get '/rsvp/search' => 'home#search'
  get '/address_update' => 'home#user_update'
  get '/update_party' => 'home#update_party'
  get '/party_guests/:id' => 'home#get_guests'

  resources :photos

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#rsvp'

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
