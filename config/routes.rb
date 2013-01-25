Quizsite::Application.routes.draw do
  
  resources :problems do
    post 'next_subproblem', :on => :collection
    post 'expand', :on => :member
    get 'example', :on => :member # although id points to a problem_type
    get 'explain', :on => :member
  end

  resources :users do
    member do
      get  'confirm'
      post 'change_password'
    end
  end

  # resources :sessions, :only => [:new, :create, :destroy]

  post "pages/check_drawing"
  post "pages/exampleprobs"

  # session pages - so the URLs make more sense
  match '/change_password' => 'users#password_form'
  # match '/signup',  :to => 'users#new'
  match '/signin',      :to => 'pages#signinpage'
  match '/signout',     :to => 'sessions#destroy'

  # student views
  get '/studenthome', :to => 'students#home'

  get '/problem_sets/:name', :to => 'problem_sets#show', :as => :problem_sets
  get '/problem_sets/:name/do/:pid', :to => 'problem_sets#do', :as => :problem_set_do
  post '/problem_sets/:name/finish_problem', :to => 'problem_sets#finish_problem', :as => :ps_finish_problem

  # teacher views:
  get '/teacherhome',               to: 'teachers#home', as: :teacherhome

  get '/details/:id',               to: 'details#details', as: :details
  post '/details_classroom',        to: 'details#select_classroom', as: :details_classroom
  post '/details_problem_set',      to: 'details#select_problem_set', as: :details_problem_set
  post '/details_concept',          to: 'details#click_concept', as: :details_concept

  get '/:classroom/:pset/new_quiz', to: 'quizzes#new', as: :new_quiz
  post '/quizzes/create',           to: 'quizzes#create', as: :create_quiz
  get '/:classroom/:pset/show',     to: 'quizzes#show', as: :quiz

  post '/:classroom/:quiz/assign'

  #
  # general static pages
  #
  get '/home',        :to => 'pages#fasthome'
  get '/features',    :to => 'pages#features'
  get '/about',       :to => 'pages#about'
  get '/access_denied', :to => 'pages#access_denied'

  #
  # static example pages
  #
  match '/draw',        :to => 'pages#draw', :via => [:get, :post]
  get '/numberline',  :to => 'pages#numberline'
  get '/graph',       :to => 'pages#graph'
  get '/datagr',       :to => 'pages#datagr'
  get '/bhutan',       :to => 'pages#bhutan'
  get '/notepad',       :to => 'pages#notepad'
  get '/measure',       :to => 'pages#measure'
  get '/dgraph',       :to => 'problem#dgraph'
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
