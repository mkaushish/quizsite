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
  end

  def team
  end

  def contact_us
  end

  def signinpage
    @container_height = 450
  end

  # TEMPORARY/TESTING PAGES
  def draw
  end
end
