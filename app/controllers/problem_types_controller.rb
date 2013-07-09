class ProblemTypesController < ApplicationController
 
    before_filter :authenticate_admin, :only => [:edit, :update]
    before_filter :validate_problem_type, :only => [:edit, :update, :show, :do_sample_problem]

    # def show
    #   @problem_type = ProblemType.includes(:problems).find(params[:id])
    #   num_probs = @problem_type.problems.length
    #   if num_probs > 0
    #     @problem = @problem_type.problems[rand(num_probs)]
    #   else
    #     @problem = @problem_type.spawn_problem
    #   end
    # end

    def edit
    end

    def update
        respond_to do |format|
            if @problem_type.update_attributes(params[:problem_type]) 
                format.html { redirect_to problem_type_path(@problem_type.id), notice: 'ProblemType was successfully updated.' }
            else
                format.html { render action: "edit" }
            end
        end
    end

    def show
    end

    def do_sample_problem
        @problem = @problem_type.spawn_problem
        respond_to { |format| format.js }
    end
  
    def finish_sample_problem
        @answer = Answer.create params: params
        @is_ans_correct = @answer.correct
        @problem = @answer.problem.problem
        @solution = @problem.prefix_solve
        @response = @answer.response_hash
        render 'show_sample_prob_ans'
    end

    private
    def validate_problem_type
       @problem_type = ProblemType.find_by_id(params[:id]) 
    end
end