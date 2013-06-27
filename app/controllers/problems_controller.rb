class ProblemsController < ApplicationController
    include ProblemHelper

    def index
        @chapters = ProblemSet
        @custom_problems = signed_in? && current_user.problem_types
    end

    def show
        @db_problem = Problem.find(params[:id])
        @solution = @db_problem.solve
        @response = @solution
        @answer = Answer.new(:problem => @db_problem, :correct => true)
        @problem = @db_problem.problem
        render 'answers/show'
    end
end
