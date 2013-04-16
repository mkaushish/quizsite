class ClassroomsController < ApplicationController
  before_filter :teacher?, :except => [:show]

  ## GET /assign_pset, remote => true
  def assign_pset
    # TODO get classroom, select problem set, option to create new one
    # - might be best as a popover
    # - try to use as much of the same shit for assign quiz as possible

    @classroom = Classroom.find(params[:id])
    @sg_psets = ProblemSet.master_sets
    @my_psets = current_user.problem_sets
  end

  def assign_quiz
  end

  def show
  end

  def new
    @classroom = current_user.classrooms.new
  end

  def create
  end

  def edit
  end

  private
  
  def teacher?
    deny_access unless current_user.is_a?(Teacher)
  end
end
