class ClassroomsController < ApplicationController
  before_filter :teacher?, :except => [:show]
  before_filter :validate_teacher, :only => [:new, :create]
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
    @classroom = Classroom.find(params[:id])
    unless @classroom.teacher == current_user
      render :js => 'alert("this class doesn\'t belong to you!");'
    end

    @quiz = Quiz.find(params[:quiz_id])
    @classroom.assign!(@quiz)
    render :js => "window.location.href = '/'"
  end

  def show
  end

  def new
    @classroom = @teacher.classrooms.build
    respond_to do |format|
      format.js
    end
  end

  def create
    @classroom = @teacher.classrooms.build(params[:classroom])
    respond_to do |format|
      if @classroom.save
        format.html { redirect_to teacherhome_path, notice: 'Classroom was successfully created.' }
      else
        format.html { render action: "new" }
      end
    end
  end

  def edit
  end

  private
  
  def teacher?
    deny_access unless current_user.is_a?(Teacher)
  end

  def validate_teacher
    @teacher = Teacher.find_by_id(params[:id])
  end
end
