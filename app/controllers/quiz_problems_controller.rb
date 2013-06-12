class QuizProblemsController < ApplicationController
	include TeachersHelper
  	before_filter :authenticate

  	def edit
  		@quiz_problem = QuizProblem.find_by_id(params[:quiz_prob])
  		respond_to do |format|
  		 	format.js
  		end
  	end

    # For showing different random problems #
    def next_random_prob
        @quiz_problem = QuizProblem.find_by_id(params[:quiz_prob])
        @problem_type = ProblemType.find_by_id(params[:ptype])
        @problem = @problem_type.spawn_problem
        @answer = @problem.solve
        respond_to do |format|
          format.js
        end
    end

    # For showing different custom problems #
    def next_custom_prob
        @quiz_problem = QuizProblem.find_by_id(params[:quiz_prob])
        @problem = current_user.custom_problems.offset(rand(current_user.custom_problems.count)).first if @quiz_problem.problem_category == "2"
        @answer = @problem.solve
        respond_to do |format|
          format.js
        end
    end

    # For updating problems_category for the quiz_problem #
    def update_problem_category
        @quiz_problem = QuizProblem.find_by_id(params[:quiz_prob])
    	if @quiz_problem.update_attributes(params[:quiz_problem])
            if @quiz_problem.problem.nil?
                @problem_type = ProblemType.find(@quiz_problem.problem_type_id)
                @problem = @problem_type.spawn_problem if @quiz_problem.problem_category == "1"
                @problem = current_user.custom_problems.offset(rand(current_user.custom_problems.count)).first if @quiz_problem.problem_category == "2"
                @answer = @problem.solve
            else
                redirect_to root_path
            end
        else
            redirect_to root_path
    	end
  	end

    # For updating chosen problem for the quiz_problem #
    def update_problem
        @quiz_problem = QuizProblem.find_by_id(params[:quiz_prob])
        respond_to do |format|
            if @quiz_problem.update_attributes(params[:quiz_problem])
                format.js 
            else
                format.html { redirect_to root_path }
            end
        end
    end

    def destroy
        @quiz_problem = QuizProblem.find_by_id(params[:quiz_prob])
        @quiz_problem.destroy
        respond_to do |format|
            format.js
        end
    end
end
