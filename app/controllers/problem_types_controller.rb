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
end
