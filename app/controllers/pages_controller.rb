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
      @nav_selected = "home"
      @jsonload = 'homeOnLoad("home");'
    end
  end
  def nologinhome
    if signed_in?
      @user = current_user;
      @title = @user.name
      @problemanswers = @user.problemanswers
      render 'users/show'
    else
      @fastnav = true
      @container_height = 500
      @nav_selected = "home"
      @jsonload = 'homeOnLoad("home");'
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
      @jsonload = 'startShow();'
    end
  end

  def features
    @fastnav = true
    @title = "Features"
    @nav_selected = "features"
    @container_height = 950
    @jsonload = 'homeOnLoad("features");'
    render 'fasthome'
  end

  def about
    @fastnav = true
    @title = "About Us"
    @nav_selected = "about"
    @container_height = 475
    @jsonload = 'homeOnLoad("about");'
    render 'fasthome'
  end

  def signinpage
    @title = "Sign In"
    @nav_selected = "signinpage"
    @container_height = 475
  end

  def exampleprobs
    @title = "Examples"
    @nav_selected = "features"

    unless params["problem_id"].nil?
      @lastproblem = Problem.find(params["problem_id"])
      @lastproblem.load_problem
      @correct = @lastproblem.correct?(params);
    end

    @problem = Problem.new
    @problem.my_initialize(Chapter1::EstimateArithmetic);
    @problem.save
    @container_height = 475
  end

  def numberline
    @title = "Number Line"
    @container_height = 650
    @nav_selected = "features"
  end

  def graph
    @title = "Graph"
    @container_height = 750 
    @nav_selected = "features"
  end

  def draw
    @title = "Draw"
    @container_height = 525
    @nav_selected = "features"
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
