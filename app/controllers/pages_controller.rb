require 'c1'
class PagesController < ApplicationController

  def fasthome
    if signed_in?
      @user = current_user;
      @title = @user.name
      @problemanswers = @user.problemanswers
      render 'users/show'
    else
      @fastnav = true
      @container_height = 500
      @jsonload = "onload=homeOnLoad(\"#{params[:page]}\");"
    end
  end

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
    @container_height = 950
  end

  def about
    @title = "About Us"
    @container_height = 475
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
    @container_height = 650
  end

  def graph
    @title = "Graph"
    @container_height = 750 
  end

  def draw
    @title = "Draw"
    @container_height = 525
    # center at 275,200
    x = 0
    y = 0
    if(rand(2) == 1)
      x = rand(125)
      y = rand(20)  + 50
    else
      x = rand(75) + 50
      y = rand(75)
    end
    y = -y if(rand(2) == 1)

    @x1 = 275 - x
    @y1 = 200 - y
    @x2 = 275 + x
    @y2 = 200 + y
  end
end
