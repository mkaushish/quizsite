class UsersController < ApplicationController
  before_filter :authenticate, :only => [:show]

  def new
  end

  def show
    #@user = User.find(params[:id])
    @user = current_user
    @title = "Profile"
    @nav_selected = "profile"
    @problemanswers = @user.problemanswers
  end

  private

  def authenticate
    deny_access unless signed_in?
  end

end
