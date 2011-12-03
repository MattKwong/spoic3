Spoic3::Application.routes.draw do

  ActiveAdmin.routes(self)

  devise_for :admin_users, ActiveAdmin::Devise.config

  #resources :groups
  match "registration/register", :to => 'registration#register'
  match "registration/:id/update", :to => 'registration#process_payment', :as => 'registration_payment'
  match "registration/:id/finalize" => 'registration#finalize', :as => 'registration_finalize'
  match "registration/:id/successful" => 'registration#successful', :as => 'registration_success'
  match "registration/show_schedule" => 'registration#show_schedule'
  match "registration/:id/schedule" => 'registration#schedule', :as => 'schedule_request'

  resources :scheduled_groups

  resources :registration do
    post 'create'
    put :edit
    put 'process_payment'
  end

  match "registration", :to => 'registration#index', :as => 'registrations'
  match "registration/show_schedule", :to => 'registration#show_schedule'
  match "registration/schedule", :to => 'registration#schedule'
  match "registration/update", :to => 'registration#update'
  match "registration/delete", :to => 'registration#delete'

 # match "groups/register_group", :to => 'groups#create', :as => 'liaison'

    match '/admin', :to => 'admin#index'
    match '/food', :to => 'pages#food'
    match 'RegistrationController', :to => 'pages#groups'
    match '/construction', :to => 'pages#construction'
    match '/help', :to => 'pages#help'
    match '/contact', :to => 'pages#contact'
    match '/about', :to => 'pages#about'
    match '/signin', :to => 'pages#home'
    match '/signout', :to => 'pages#home'
    root :to => 'pages#home'

  get "churches/new"

  get "churches/edit"

  get "churches/delete"

  get "churches/show"

  get "liaisons/new"

  get "liaisons/edit"

  get "liaisons/delete"

  get "liaisons/show"

  get "program_type/show"

  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
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

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => "welcome#index"

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
end
