require 'c1'
class PagesController < ApplicationController
  def home
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

  def blog
  end

  def contact_us
  end

  # TEMPORARY/TESTING PAGES
  def draw
  end
end
