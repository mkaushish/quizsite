class QuizProblemsController < ApplicationController
	include TeachersHelper
  	before_filter :authenticate

  	def edit
  		
  		@quiz_problem = QuizProblem.find_by_id(params[:id])
      
  		respond_to do |format|
  		 	format.js
  			#format.html
  		end
  	end

    def do_prob
      # if defined? params[:problem_category]
      #   case params[:problem_category]
      #   when 1
           @problem_type = ProblemType.find_by_id(params[:ptype_id])
          @problem = @problem_type.spawn_problem
      #   end
      # end
      respond_to do |format|
        format.js
      end
    end

  	def update
    	@quiz_problem = QuizProblem.find_by_id(params[:id])
    	respond_to do |format|
      		if @quiz_problem.update_attributes(params[:quiz_problem]) 
        		format.html redirect_to root_path
      		else
        		format.html { render action: "edit" }
      		end
    	end
  	end
end
