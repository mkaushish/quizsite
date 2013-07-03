Quizsite::Application.routes.draw do
  resources :badges

  resources :problem_sets, only: [:show, :edit, :create, :update, :destroy]
  get '/problem_set/:id',  to: 'problem_sets#view', as: :view_problem_set
  get '/problem_sets/:id/edit_pset',:to => 'problem_sets#edit_pset'
  put '/problem_sets/update_pset/:id', :to => 'problem_sets#update_pset', as: :update_pset_info
  
  resources :custom_problems, except: [:index]
  get '/problems/:id', to: 'problems#show', as: :problem
  
  match "/auth/:provider/callback" => "users#create_user_vdp"
  resources :users do
    member do
      get  'confirm'
      post 'change_password'
    end
  end

  get 'problems/:id', to: 'problems#show', as: :problem
  
  match "/auth/:provider/callback" => "users#create_user_vdp"

  post "pages/check_drawing"
  post "pages/exampleprobs"
  get "/sample_problem/do/:id", :to => 'problem_types#do_sample_problem', :as => :do_sample_problem
  post "/sample_problem/finish/:id", :to => 'problem_types#finish_sample_problem', :as => :finish_sample_problem

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
  get '/student/edit',:to => 'students#edit', :as => :edit_student
  get '/student/notifications',:to => 'students#notifications', :as => :notifications_student
  put '/students/:id', :to => 'students#update', :as => :update_student
  get '/students/:id', :to => 'students#show', :as => :student

  # student-problem_set_instances views
  get '/psets/:name', :to => 'problem_set_instances#show', :as => :pset
  get '/psets/:name/do/:pid', :to => 'problem_set_instances#do', :as => :pset_do
  get '/psets/:name/static_do/:pid', :to => 'problem_set_instances#static_do', :as => :problem_set_static_do
  post '/psets/:name/finish_problem', :to => 'problem_set_instances#finish_problem', :as => :finish_ps_problem

  # student-quiz_instances views
  get '/quiz/do/:pid',          :to => 'quiz_instances#do',    :as => :quiz_do
  get '/quiz/:id/start',        :to => 'quiz_instances#start', :as => :start_quiz
  get '/quiz/:id/start_new',    :to => 'quiz_instances#new',   :as => :start_new_quiz
  get '/quiz/:id/finish',       :to => 'quiz_instances#finish_quiz',:as => :finish_quiz
  get '/left_problem', :to => 'quiz_instances#previous_problem',   :as => :left_quiz_problem
  get '/quiz/:id/next_problem', :to => 'quiz_instances#next_problem',   :as => :next_quiz_problem
  post '/quiz/finish_problem',  :to => 'quiz_instances#finish_problem', :as => :finish_quiz_problem


  # student-answers views
  get '/answers/:id/show', to: 'answers#show', as: :show_answer
  get '/answers/:id/show', to: 'answers#sample_prob_show', as: :sample_prob_show_answer
  get '/answers/:id/static_show', to: 'answers#static_show', as: :static_show_answer

  # student-explanations views
  get '/:id/explain',          to: 'explanations#explain', as: :explain_problem
  post '/:id/explain/expand',  to: 'explanations#expand', as: :expand
  post '/:id/explain/next',    to: 'explanations#next_subproblem', as: :next_subproblem

  # student-problem_types views
  get '/problem_type/:id',  to: 'problem_types#show', as: :problem_type
  get '/problem_type/:id/edit',  to: 'problem_types#edit', as: :edit_problem_type
  put '/problem_type/:id',  to: 'problem_types#update'
  post '/problems/:id/finish', to: 'problems#finish', as: :finish_problem

  # teacher views:
  get '/teacherhome',               to: 'teachers#home', as: :teacherhome
  post '/teachers', to:'teachers#create', as: :teachers

  get  '/details/:id',               to: 'details#details', as: :details
  post '/details_classroom',        to: 'details#select_classroom', as: :details_classroom
  post '/details_problem_set',      to: 'details#select_problem_set', as: :details_problem_set
  post '/details_concept',          to: 'details#click_concept', as: :details_concept

  get '/:classroom/:pset/new_quiz', to: 'quizzes#new', as: :new_quiz
  get '/quiz_for_all_classes',      to: 'quizzes#new_for_all', as: :new_quiz_for_all
  get '/quiz_with_all_ptypes',      to: 'quizzes#new_quiz_with_all_ptypes', as: :new_quiz_with_all_ptypes


  post '/quizzes/create',           to: 'quizzes#create', as: :create_quiz
  post '/:classroom/:pset/partial_create',   to: 'quizzes#partial_create', as: :partial_create_quiz
  post '/quiz_for_all_classes/:quiz',   to: 'quizzes#create_qp_for_all', as: :create_qp_for_all
  post '/quiz_with_all_ptypes/:quiz',   to: 'quizzes#create_qp_with_all_ptypes', as: :create_qp_with_all_ptypes
  
  get '/quiz_for_all_classes/:quiz',    to: 'quizzes#assign_quiz_to_classrooms', as: :assign_quiz_to_classrooms

    
  # post ':classroom/assign_quiz/:id', to: 'quizzes#assign', as: :assign_quiz
  get '/:classroom/:pset/show',     to: 'quizzes#show', as: :quiz
  post '/:classroom/:quiz/assign'

  # :id => classroom id
  get  ':id/show_psets/', to: 'classrooms#show_psets', as: :show_psets
  get  ':id/show_quizzes/', to: 'classrooms#show_quizzes', as: :show_quizzes
  get ':id/assign_pset/:pset_id', to: 'classrooms#assign_pset', as: :assign_pset
  get ':id/assign_quiz/:quiz_id', to: 'classrooms#assign_quiz', as: :assign_quiz

  #
  # general static pages
  #
  get '/home',          :to => 'pages#home'
  get '/what_is_it',    :to => 'pages#what_is_it'
  get '/about_us',      :to => 'pages#about_us'
  get '/draw',          :to => 'pages#draw'
  get '/access_denied', :to => 'pages#access_denied'

  # quiz_problems 
  match '/quiz_problem/:quiz_prob/edit' => 'quiz_problems#edit', :via => :get, as: :edit_quiz_problem
  match '/quiz_problem/:quiz_prob/update_prob_cat' => 'quiz_problems#update_problem_category', :via => :put, as: :update_prob_cat_qp
  match '/quiz_problem/:quiz_prob/update_problem' => 'quiz_problems#update_problem', :via => :put, as: :update_problem_qp
  get 'quiz_problem/:quiz_prob/ptype/:ptype', :to => 'quiz_problems#next_random_prob', :as => :next_random_prob_qp
  get 'quiz_problem/:quiz_prob/', :to => 'quiz_problems#next_custom_prob', :as => :next_custom_prob_qp
  delete 'quiz_problem/:quiz_prob/', :to => 'quiz_problems#destroy', :as => :delete_quiz_problem

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
