class QuizProblemsController < ApplicationController
	include TeachersHelper
  	before_filter :authenticate
    before_filter :validate_quiz_problem_and_quiz, except: [:new, :update_problem_category, :update_problem]

  	def new
        @problem_type       = ProblemType.find_by_id(params[:problem_type_id])
        @quiz_problem       = QuizProblem.new(:problem_type_id => @problem_type.id)
        @f                  = params[:f] if defined? params[:f]
        respond_to do |format|
            format.js
        end
    end

    def edit
  		respond_to do |format|
  		 	format.js
  		end
  	end

    # For showing different random problems #
    def next_random_prob
        @problem_type       = ProblemType.find_by_id(params[:ptype])
        @problem            = @problem_type.spawn_problem
        @answer             = @problem.solve
        @f                  = params[:f]                if defined? params[:f]
        @problem_category   = "1"
        respond_to do |format|
          format.js
        end
    end

    # For showing different custom problems #
    def next_custom_prob
        @problem            = current_user.custom_problems.offset(rand(current_user.custom_problems.count)).first if @quiz_problem.problem_category == "2"
        @answer             = @problem.solve
        @f                  = params[:f]                if defined? params[:f]
        @problem_category   = "2"
        respond_to do |format|
          format.js
        end
    end

    # For updating problems_category for the quiz_problem #
    def update_problem_category
        @problem_category   = params[:problem_category] if defined? params[:problem_category]
        @problem_type_id    = params[:problem_type_id]  if defined? params[:problem_type_id]
        @f                  = params[:f]                if defined? params[:f]
        @problem_type       = ProblemType.find(@problem_type_id)
        @problem            = @problem_type.spawn_problem if @problem_category == "1"
        @problem            = current_user.custom_problems.offset(rand(current_user.custom_problems.count)).first if @problem_category == "2"
        @answer             = @problem.solve
        respond_to do |format|
            format.js
        end
  	end

    # For updating chosen problem for the quiz_problem #
    def update_problem
        @problem            = Problem.find_by_id(params[:problem]) if defined? params[:problem]
        @problem_type       = ProblemType.find_by_id(params[:problem_type_id]) if defined? params[:problem_type_id]
        @problem_category   = params[:problem_category] if defined? params[:problem_category]
        @f                  = params[:f]                if defined? params[:f]
        respond_to do |format|
            format.js
        end
    end

    def destroy
        @quiz_problem.destroy
        respond_to do |format|
            format.js
        end
    end

    private
    
    def validate_quiz_problem_and_quiz
        @quiz_problem   = QuizProblem.find_by_id(params[:quiz_prob])
        #@quiz = @quiz_problem.quiz
    end
end
