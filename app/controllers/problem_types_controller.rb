class ProblemTypesController < ApplicationController
  def show
    @problem_type = ProblemType.find(params[:id])
    @problem = @problem_type.problems.last ||
               @problem_type.spawn_problem
  end
end
