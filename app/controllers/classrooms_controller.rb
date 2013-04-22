class ClassroomsController < ApplicationController
  before_filter :teacher?, :except => [:show]

  def show_psets
    @classroom = Classroom.find(params[:id])
    @sg_psets = ProblemSet.master_sets
    @my_psets = current_user.problem_sets
  end

  def show_quizzes
  end

  ## GET /assign_pset, remote => true
  def assign_pset
    @classroom = Classroom.find(params[:id])
    unless @classroom.teacher == current_user
      render :js => 'alert("this class doesn\'t belong to you!");'
    end

    @pset = ProblemSet.find(params[:pset_id])
    @classroom.assign!(@pset)
    render :js => "window.location.href = '/'"
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
