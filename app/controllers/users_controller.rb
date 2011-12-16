class UsersController < ApplicationController
  before_filter :authenticate, :only => [:show]

  def new
  end

  def show
    # TODO what should users be able to see on other users' profiles?
    # TODO Make PROFILE PATH
    @user = User.find(params[:id])
    @title = @user.name
    @problemanswers = @user.problemanswers
  end

  private

  def authenticate
    deny_access unless signed_in?
  end

end
