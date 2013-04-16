Quizsite::Application.routes.draw do
  resources :problem_sets, only: [:show, :edit, :create, :update, :destroy]

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
  match '/signin',      :to => 'sessions#create'
  match '/signout',     :to => 'sessions#destroy'
  match '/register',    :to => 'users#register', :as => :register

  # student views
  get '/studenthome', :to => 'students#home'
  get '/students/new',:to => 'students#new', :as => :new_student
  post '/students',   :to => 'students#create', :as => :students

  get '/psets/:name', :to => 'problem_set_instances#show', :as => :pset
  get '/psets/:name/do/:pid', :to => 'problem_set_instances#do', :as => :pset_do
  get '/psets/:name/static_do/:pid', :to => 'problem_set_instances#static_do', :as => :problem_set_static_do
  post '/psets/:name/finish_problem', :to => 'problem_set_instances#finish_problem', :as => :ps_finish_problem

  get '/answers/:id/show', to: 'answers#show', as: :show_answer
  get '/answers/:id/static_show', to: 'answers#static_show', as: :static_show_answer

  get '/:id/explain',          to: 'explanations#explain', as: :explain_problem
  post '/:id/explain/expand',  to: 'explanations#expand', as: :expand
  post '/:id/explain/next',    to: 'explanations#next_subproblem', as: :next_subproblem

  get '/problem_type/:id',  to: 'problem_types#show', as: :problem_type
  post '/problems/:id/finish', to: 'problems#finish', as: :finish_problem

  # teacher views:
  get '/teacherhome',               to: 'teachers#home', as: :teacherhome
  post '/teachers', to:'teachers#create', as: :teachers

  get  '/details/:id',               to: 'details#details', as: :details
  post '/details_classroom',        to: 'details#select_classroom', as: :details_classroom
  post '/details_problem_set',      to: 'details#select_problem_set', as: :details_problem_set
  post '/details_concept',          to: 'details#click_concept', as: :details_concept

  get '/:classroom/:pset/new_quiz', to: 'quizzes#new', as: :new_quiz
  post '/quizzes/create',           to: 'quizzes#create', as: :create_quiz
  get ':classroom/assign_quiz/:id', to: 'quizzes#assign', as: :assign_quiz
  get '/:classroom/:pset/show',     to: 'quizzes#show', as: :quiz

  post '/:classroom/:quiz/assign'

  # :id => classroom id
  get '/assign_pset/:id', to: 'classrooms#assign_pset', as: :assign_pset
  get '/assign_quiz/:id', to: 'classrooms#assign_quiz', as: :assign_pset

  #
  # general static pages
  #
  get '/home',          :to => 'pages#home'
  get '/what_is_it',    :to => 'pages#what_is_it'
  get '/about_us',      :to => 'pages#about_us'
  get '/draw',          :to => 'pages#draw'
  get '/access_denied', :to => 'pages#access_denied'

  #
  # static example pages
  #
  # match '/draw',        :to => 'pages#draw', :via => [:get, :post]
  # get '/numberline',    :to => 'pages#numberline'
  # get '/graph',         :to => 'pages#graph'
  # get '/datagr',        :to => 'pages#datagr'
  # get '/bhutan',        :to => 'pages#bhutan'
  # get '/notepad',       :to => 'pages#notepad'
  # get '/measure',       :to => 'pages#measure'
  # get '/dgraph',        :to => 'problem#dgraph'

  # match '/nologinhome_3dbfabcacc12868a282be76f5d59a19813', :to => 'pages#nologinhome'
  root                  :to => 'pages#home'

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
