require 'c1'
require 'c2'
require 'c3'
require 'c6'
require 'c7'
require 'physics'

class AnswersController < ApplicationController
  # GET /answers
  # GET /answers.json
  def index
    @answers = current_user.answers

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @answers }
    end
  end

  # GET /answers/1
  # GET /answers/1.json
  def show
    @answer = Answer.find(params[:id]).includes(:problem)
    @problem = @answer.problem.problem
    @solution = @problem.prefix_solve
    puts "^"*60
    puts @solution.inspect
    @response = @answer.response_hash

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @answer }
      format.js { render 'show_answer'}
    end
  end


  def explain
    @bigproblem = Problem.find(params["problem_id"])
    if @bigproblem.is_a? QuestionWithExplanation
      @subproblems = @bigproblem.explain
    end
  end

  # POST /answers
  # POST /answers.json
end
