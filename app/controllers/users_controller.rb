class UsersController < ApplicationController
  before_filter :authenticate, :only => [:show]

  def new
  end

  def show
    @title = "Profile"
    @nav_selected = "profile"

    @quizzes = current_user.quizzes
    @shownquiz = @quizzes.first unless @quizzes.empty?
    @problemanswers = current_user.problemanswers
  end

  private

  def authenticate
    deny_access unless signed_in?
  end

end
