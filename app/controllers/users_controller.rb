class UsersController < ApplicationController
  def new
  end

  def show
    # TODO what should users be able to see on other users' profiles?
    @user = User.find(params[:id])
    @title = @user.name
    @problemanswers = @user.problemanswers
  end

end
