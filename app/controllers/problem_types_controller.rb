class ProblemTypesController < ApplicationController
  # def show
  #   @problem_type = ProblemType.includes(:problems).find(params[:id])
  #   num_probs = @problem_type.problems.length
  #   if num_probs > 0
  #     @problem = @problem_type.problems[rand(num_probs)]
  #   else
  #     @problem = @problem_type.spawn_problem
  #   end
  # end

  before_filter :authenticate_admin, :only => [:edit, :update]

  def edit
    @problem_type = ProblemType.find_by_id(params[:id])
  end

  def update
    @problem_type = ProblemType.find_by_id(params[:id])
    respond_to do |format|
      if @problem_type.update_attributes(params[:problem_type]) 
        format.html { redirect_to problem_type_path(@problem_type.id), notice: 'ProblemType was successfully updated.' }
      else
        format.html { render action: "edit" }
      end
    end
  end

  def show
    @problem_type = ProblemType.find_by_id(params[:id])
  end

  def do_sample_problem
    @problem_type = ProblemType.find_by_id(params[:id])
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

end
