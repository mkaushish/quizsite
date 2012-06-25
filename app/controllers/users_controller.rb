class UsersController < ApplicationController
  before_filter :authenticate, :only => [:show]

  def new
    @user = User.new
  end
  
  # POST confirm
  def confirm
    @user = User.find params['id']

    if @user.confirmed?
      # were confirmed before this shit...
      redirect_to root_path

    elsif @user.confirm(params['code'])
      @user.save( :validate => false )
      sign_in @user
      redirect_to profile_path

    else
      render 'confirmation_error'
    end
  end

  def show
    stop_quiz
    @title = "Profile"
    @nav_selected = "profile"

    @quizzes = current_user.quizzes
    @shownquiz = @quizzes.first unless @quizzes.empty?
    @problemanswers = current_user.problemanswers
  end

  def create
    uparams = params["user"]
    @user = User.new uparams


    $stderr.puts "UPARAMS: #{uparams.inspect}"
    
    if @user.save
      UserMailer.delay.confirmation_email(@user) # normally this would be .deliver at the end
      # but not with the DelayedJob delay in there
      @user.save
      $stderr.puts("I JUST SENT THE FRICKIN EMAIL GUYS")
      render 'users/confirmjs'
    else
      @prefix = "user_"
      @errors = @user.errors
      @fields = [:name, :password, :password_confirmation, :email]

      $stderr.puts "#"*60
      $stderr.puts "COULDN'T SAVE: #{@errors.full_messages}"

      render 'shared/form_errors'
    end
  end

  private

  def authenticate
    deny_access unless signed_in?
  end

end
