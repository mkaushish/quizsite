Quizsite::Application.routes.draw do
  # 
  # resources :problems do
  #   post 'next_subproblem', :on => :collection
  #   post 'expand', :on => :collection
  #   get 'example', :on => :member
  # end

  get  "problem/index"
  post "problem/next_subproblem"
  post "problem/expand"
  match "/explain/:id" => 'problem#explain', :as => :explain
  match "problem/example/:type" => 'problem#example', :as => :problem_example
  match '/problems' => 'problem#index'

  scope(:path_names => { :new => "quiz" }) do
    resources :problemanswers, :except => [:edit, :destroy]
  end

  resources :users do
    member do
      get  'confirm'
      post 'change_password'
    end
  end

  resources :sessions, :only => [:new, :create, :destroy]

  resources :quizzes, :except => [:show] # see them in profile

  post "pages/check_drawing"
  post "pages/exampleprobs"

  match '/profile' => 'users#profile'
  match '/stats' => 'users#stats'
  match '/change_password' => 'users#password_form'
  # match '/signup',  :to => 'users#new'
  match '/signin',      :to => 'pages#signinpage'
  match '/signout',     :to => 'sessions#destroy'
  match '/history',     :to => 'problemanswers#index'
  match '/startquiz',   :to => 'problemanswers#new'
  match '/home',        :to => 'pages#fasthome'
  match '/features',    :to => 'pages#features'
  match '/about',       :to => 'pages#about'
  # TODO remove signinpage, just call it signin
  match '/signinpage',  :to => 'pages#signinpage'
  match '/draw',        :to => 'pages#draw', :via => [:get, :post]
  match '/numberline',  :to => 'pages#numberline'
  match '/graph',       :to => 'pages#graph'
  match '/datagr',       :to => 'pages#datagr'
  match '/notepad',       :to => 'pages#notepad'
  match '/measure',       :to => 'pages#measure'
  match '/estimate',    :to => 'pages#exampleprobs', :via => [:get, :post]
  # match '/nologinhome_3dbfabcacc12868a282be76f5d59a19813', :to => 'pages#nologinhome'
  root                  :to => 'pages#fasthome'

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

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
end
