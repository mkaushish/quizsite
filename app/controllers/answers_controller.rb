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

  # post /answers/1, js
  def show
    @instance = ProblemSetInstance.find(params[:instance])
    @answer = Answer.includes(:problem).find(params[:id])
    @stat = @instance.stat(@answer.problem_type)
    @problem = @answer.problem.problem
    @solution = @problem.prefix_solve
    puts "^"*60
    puts @solution.inspect
    @response = @answer.response_hash
  end

  def sample_prob_ans
    @answer = Answer.includes(:problem).find(params[:id])
    @problem = @answer.problem.problem
    @solution = @problem.prefix_solve
    puts "^"*60
    puts @solution.inspect
    @response = @answer.response_hash
  end


  def static_show
    @instance = ProblemSetInstance.find(params[:instance])
    @answer = Answer.includes(:problem).find(params[:id])
    @stat = @instance.stat(@answer.problem_type)
    @problem = @answer.problem.problem
    @solution = @problem.prefix_solve
    puts "^"*60
    puts @solution.inspect
    @response = @answer.response_hash
    render 'static_show'
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
