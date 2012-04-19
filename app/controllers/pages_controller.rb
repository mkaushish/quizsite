require 'c1'
class PagesController < ApplicationController

  def fasthome
    if signed_in?
      redirect_to profile_path
    else
      @fastnav = true
      @nav_selected = "home"
    end
  end
  def nologinhome
    if signed_in?
      @user = current_user;
      @title = @user.name
      @problemanswers = @user.problemanswers
      @nav_selected = "profile"
      render 'users/show'
    else
      @fastnav = true
      @nav_selected = "home"
    end
  end

  def features
    @fastnav = true
    @title = "Features"
    @nav_selected = "features"
    render 'fasthome'
  end

  def about
    @fastnav = true
    @title = "About Us"
    @nav_selected = "about"
    render 'fasthome'
  end

  def signinpage
    @title = "Sign In"
    @nav_selected = "signinpage"
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
    @problem.my_initialize(Chapter1::EstimateArithmetic)
    @problem.save
  end

  def numberline
    @title = "Number Line"
    @nav_selected = "features"
  end

  def graph
    @title = "Graph"
    @nav_selected = "features"
  end

  def draw
    @title = "Draw"
    @nav_selected = "features"

    @problem = Problem.new
    @problem.my_initialize(Geo::BisectLine)
    @problem.save
  end

  def check_drawing
    @lastproblem = Problem.find(params["problem_id"])
    @lastproblem.load_problem
    @correct = @lastproblem.correct?(params);
    if @correct
      @problem = Problem.new
      @problem.my_initialize(Geo::BisectLine)
      @problem.save
      @problem.text.each { |p| @newstartshapes = p.encodedStartShapes if p.is_a?(GeometryField) }
      $stderr.puts "NEWSTARTSHAPES SET TO #{@newstartshapes}"
    end
    respond_to { |format| format.js }
  end
end
