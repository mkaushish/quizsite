class UsersController < ApplicationController
  before_filter :authenticate, :only => [:show]

  def new
    @user = User.new
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
      UserMailer.confirmation_email(@user).deliver
      @user.save
      $stderr.puts("I JUST SENT THE FRICKIN EMAIL GUYS")
      render :js => "window.location = '/'"
    else
      @prefix = "user_"
      @errors = @user.errors
      @fields = [:name, :password, :email]

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
