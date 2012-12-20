class StudentsController < ApplicationController
  before_filter :authenticate, :except => [:show]

  def home
    @student = current_user
    @pset_instances = @student.problem_set_instances.includes(:problem_set)
  end

  def me
  end

  def show
  end
end
