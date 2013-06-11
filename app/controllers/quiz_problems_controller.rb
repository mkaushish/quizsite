class QuizProblemsController < ApplicationController
	include TeachersHelper
  	before_filter :authenticate

  	def edit
  		@quiz_problem = QuizProblem.find_by_id(params[:quiz_prob])
  		respond_to do |format|
  		 	format.js
  		end
  	end

    def next_prob
        @quiz_problem = QuizProblem.find_by_id(params[:quiz_prob])
        @problem_type = ProblemType.find_by_id(params[:ptype])
        @problem = @problem_type.spawn_problem
        @answer = @problem.solve
        respond_to do |format|
          format.js
        end
    end

    def update
        
    	@quiz_problem = QuizProblem.find_by_id(params[:quiz_prob])
    	if @quiz_problem.update_attributes(params[:quiz_problem])
            
            if @quiz_problem.problem.nil?
                @problem_type = ProblemType.find(@quiz_problem.problem_type_id) if @quiz_problem.problem_category == "1"
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
end
