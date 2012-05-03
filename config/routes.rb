Spoic3::Application.routes.draw do

  get "roster_item/update"

  get "scheduled_group/new"

  get "scheduled_group/confirmation"
  ActiveAdmin.routes(self)

#  devise_for :admin_users, ActiveAdmin::Devise.config
  as :admin_user do
    match '/admin_user/confirmation' => 'confirmations#update', :via => :put, :as => :update_admin_user_confirmation
  end

  devise_for :admin_users, :controllers => { :admin_users => "admin_users", :passwords => "passwords",
            :confirmations => "confirmations", :sessions => "sessions" }

  resources :admin_users

#  match "admin/confirmation/new", :to => 'active_admin/devise/confirmations#new', :as => 'new_admin_user_confirmation'

  resources :sites do
      resources :vendors, :shallow => true
  end

  resources :programs do
    resources :projects do
      resources :material_item_estimateds, :shallow => true
      resources :material_item_delivereds, :shallow => true
      resources :labor_items, :shallow => true
      resources :standard_items, :shallow => true
      end
    resources :periods, :shallow => true
    resources :purchases, :shallow => true do
    resources :item_purchases, :shallow => true
    end
    resources :food_inventories, :shallow => true
    resources :items, :shallow => true
    get :autocomplete_user_name
    get :autocomplete_item
    get :activation
  end


  resources :vendors, :only => [:index]
  resources :purchases, :only => [:index]
  resources :food_inventories, :only => [:index]
  resources :items
  resources :projects
  resources :material_item_estimateds
  resources :material_item_delivereds, :only => [:index]
  resources :labor_items, :only => [:index]
  resources :standard_items
  match "material_item_estimated/add_standard/:id", :to => 'material_item_estimateds#add_standard', :as => 'add_standard_item'

  #reports
  get "staff_report", :controller => 'staff_report', :action => 'show', :as => 'staff_report'
  get "site_reports/food_inventory/:id", :controller => 'site_reports', :action => 'food_inventory', :as => 'food_inventory_report'
  get "site_reports/food_budget/:id", :controller => 'site_reports', :action => :food_budget, :as => 'food_budget_report'
  get "site_reports/food_consumption/:id", :controller => :'site_reports', :action => :food_consumption, :as => 'food_consumption_report'
  get "site_reports/session/:id", :controller => 'site_reports', :action => :session, :as => 'session_report'

  match "material_item_delivereds/add/:id", :to => 'material_item_delivereds#new', :as => 'deliver_project'
  match "material_item_delivereds", :to => 'material_item_delivereds#create', :as => 'add_material_item'
  match "labor_item", :to => 'labor_items#create', :as => 'add_labor_item'
  match "labor_items/add/:id", :to => 'labor_items#new', :as =>'labor_project'

  match "move_stage/:id" => 'projects#move_stage', :as =>'project_review'

  match "registration/schedule", :to => 'registration#schedule', :as => "registration_schedule"
  match "registration/register", :to => 'registration#register'
  match "registration/:id/update", :to => 'registration#process_payment', :as => 'registration_payment'
  match "registration/:id/finalize" => 'registration#finalize', :as => 'registration_finalize'
  match "registration/:id/successful" => 'registration#successful', :as => 'registration_success'
  match "registration/show_schedule" => 'registration#show_schedule'

  match "registration/:id/schedule" => 'registration#schedule', :as => 'schedule_request'
  match "registration/:id/program_session" => 'registration#program_session', :as => 'reg_program_session'
  match "registration/alt_schedule" => 'registration#alt_schedule', :as => 'alt_schedule_group'
  match "scheduled_groups/:id/program_session" => 'scheduled_groups#program_session', :as => 'sched_program_session'

  match "scheduled_groups/:id/schedule" => 'scheduled_groups#confirmation', :as => "scheduled_groups_schedule"
  match "scheduled_groups/:id/success" => 'scheduled_groups#success', :as => "scheduled_group_confirmation"
  match "scheduled_groups/:id/change_success" => 'scheduled_groups#change_success', :as => "change_confirmation"
  match "liaisons/:id/create_user" => 'liaisons#create_user', :as => 'create_user'
  match "payment/:group_id/new" => 'payment#new', :as => "record_payment"
  match "payments" => 'payment#create', :as => 'payments'
  match "payment/:id" => 'payment#show', :as => 'show_payment'
  match "adjustment/:group_id/new" => 'adjustment#new', :as => "make_adjustment"
  match "adjustments" => 'adjustment#create', :as => 'adjustments'

  match "scheduled_groups/:id/invoice" => 'scheduled_groups#invoice', :as => "invoice"
  match "scheduled_groups/:id/statement" => 'scheduled_groups#statement', :as => "statement"
  match "budget/budget_summary" => 'budget#budget_summary', :as => "budget_show"
  match "roster_item/new" => 'roster_item#new', :as => 'new_roster_item'
  match "roster_items" => 'roster_item#create', :as => 'roster_items'
  match "roster_items/:id" => 'roster_item#edit', :as => 'edit_roster_item'
  match "roster_items/:id/delete" => 'roster_item#delete', :as => 'delete_roster_item'
  match "rosters/:id" => 'rosters#show', :as => "show_roster"
#  match "rosters/:id" => 'rosters#update', :as => "update_roster_items"

  resources :roster_item do
#    show 'show'
     post 'update'
   end

  resources :registration do
    post 'create'
    put :edit
    put 'process_payment'
  end
  match "scheduled_groups/invoice_report" => 'scheduled_groups#invoice_report', :as => 'invoice_report'
  match "scheduled_groups/invoice_report.csv" => 'scheduled_groups#invoice_report', :as => 'invoice_report_csv'
  match "reports/church_and_liaison" => 'reports#church_and_liaison', :as => 'church_and_liaison_csv'
  match "reports/scheduled_liaisons" => 'reports#scheduled_liaisons', :as => 'scheduled_liaisons_csv'
  match "reports/scheduled_liaisons" => 'reports#scheduled_liaisons', :as => 'scheduled_liaisons_html'

  resources :vendors
  resources :churches
  resources :liaisons
  resources :scheduled_groups
#  match "liaisons/edit/:id", :to => 'liaisons#edit', :as => 'edit_liaison'
#  match "churches/edit/:id", :to => 'churches#edit', :as => 'edit_church'
  match "churches/main/:id", :to => 'liaisons#show', :as => "myssp"
  match "churches/main/:id", :to => 'liaisons#show', :as => "liaison"
  match "registration", :to => 'index', :as => 'registrations'
  match "registration/show_schedule", :to => 'registration#show_schedule'
  match "registration/update", :to => 'registration#update'
  match "registration/delete", :to => 'registration#delete'
  match 'RegistrationController', :to => 'pages#groups'

  match '/admin', :to => 'admin#index'
  match 'ops_pages/food', :to => 'ops_pages#food', :as => 'food'
  match 'ops_pages/show', :to => 'ops_pages#show', :as => 'ops_pages_show'
  match 'ops_pages/construction', :to => 'ops_pages#construction', :as => 'construction'
  match 'ops_pages/staff', :to => 'ops_pages#staff', :as => 'staff'
  match 'ops_pages/index', :to => 'ops_pages#index', :as => 'ops_indx'

  match '/help', :to => 'pages#help', :as => 'help'
  match '/contact', :to => 'pages#contact'
  match '/about', :to => 'pages#about'
  match '/signin', :to => 'pages#home'
  match '/signout', :to => 'pages#home'
  root :to => 'pages#home'

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
