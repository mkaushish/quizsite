class ProblemTypesController < ApplicationController
  def show
    @problem_type = ProblemType.includes(:problems).find(params[:id])
    num_probs = @problem_type.problems.length
    if num_probs > 0
      @problem = @problem_type.problems[rand(num_probs)]
    else
      @problem = @problem_type.spawn_problem
    end
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
    
    render 'answers/sample_prob_show', locals: {callback: 'problem_types/finish_sample_problem'}
  end

end
