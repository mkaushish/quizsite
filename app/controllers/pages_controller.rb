require 'c1'
class PagesController < ApplicationController
  def home
    @container_height = 500
    if signed_in?
      @user = current_user;
      @title = @user.name
      @problemanswers = @user.problemanswers
      render 'users/show'
    else
      @jsonload = 'onload=startShow();'
    end
  end

  def features
    @title = "Features"
    @container_height = 1100
  end

  def team
    @title = "Team"
  end

  def contact
    @title = "Contact"
    @container_height = 475
  end

  def signinpage
    @title = "Sign In"
    @container_height = 475
  end

  def numberline
    @title = "Number Line"
  end

  def numberline
   @title='Number Line' 
  end
  def draw
    @title = "Draw"
    @container_height = 475
  end
end
