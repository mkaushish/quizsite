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
    @user = User.new(params[:id])
    
    # soon we'll need  to differentiate here
    if @user.save
      redirect_to root_path
    else
      redirect_to root_path
    end
  end
  private

  def authenticate
    deny_access unless signed_in?
  end

end
