require 'c1'
require 'c2'
require 'c3'
require 'c6'
require 'c7'
require 'physics'

class AnswersController < ApplicationController

    before_filter :validate_student
    before_filter :validate_instance, :only => [:show, :static_show]
    before_filter :validate_answer, :only => [:show, :sample_prob_ans, :static_show]

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
        @instance ||= ProblemSetInstance.last
        @answer = Answer.includes(:problem).find(params[:id])
        @stat = @instance.stat(@answer.problem_type)
        @problem = @answer.problem.problem
        @solution = @problem.prefix_solve
        @comments = @answer.comments.includes(:user)
        @comment = Comment.new
        puts "^"*60
        puts @solution.inspect
        @response = @answer.response_hash
    end

    # def show_answer_home_page
    #   @answer = current_user.answers.includes(&:problem_set_instance)
    #   @problem = @answer.problem.problem
    #   @solution = @problem.prefix_solve
    #   @response = @answer.response_hash
    # end

    def sample_prob_ans
        @answer = Answer.includes(:problem).find(params[:id])
        @problem = @answer.problem.problem
        @solution = @problem.prefix_solve
        puts "^"*60
        puts @solution.inspect
        @response = @answer.response_hash
    end



    def static_show
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

    private
    
    def validate_student
        @student = current_user
    end

    def validate_instance
        @instance = ProblemSetInstance.find(params[:instance])
    end

    def validate_answer
        @answer = Answer.includes(:problem).find(params[:id])
    end
end
