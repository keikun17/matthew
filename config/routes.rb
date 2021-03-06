Matthew::Application.routes.draw do
  resources :products

  resources :devex_users do
    resources :transactions
    resources :paypal_accounts
  end

  resources :paypal_accounts do 
    collection do 
      get 'orphans'
    end
    member do 
      get 'map'
    end
    resources :transactions
  end
  
  devise_for :admins

  resources :transactions do 
    member do 
      get 'upload_to_qb'
    end
    collection do 
      get 'prepare_batch_upload_to_qb'
    end
  end
  match '/ipn' => 'paypal#ipn'
  match '/mappings/do_map' => 'mappings#do_map'
  resources :mappings
  resources :reports do
    collection do 
      get 'export'
    end
  end
  resources :users do 
    collection do 
      post 'find_users'
    end
  end


  match '/bulk_upload_sales_receipts_to_quickbooks' => 'transactions#bulk_upload_sales_receipts_to_quickbooks'
  match '/bulk_upload_credit_memos_to_quickbooks' => 'transactions#bulk_upload_credit_memos_to_quickbooks'  
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
  root :to => "reports#index"

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
end
