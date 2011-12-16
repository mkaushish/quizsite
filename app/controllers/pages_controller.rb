class PagesController < ApplicationController
  def home
    if signed_in?
      @user = current_user;
      @title = @user.name
      @problemanswers = @user.problemanswers
      render 'users/show'
    end
  end

  def contact
  end

  def team
  end

end
