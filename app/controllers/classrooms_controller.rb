class ClassroomsController < ApplicationController

  before_filter :teacher?, :except => [:show]
  before_filter :validate_teacher, :only => [:new, :create, :join, :join_class]
  before_filter :validate_teacher_via_current_user, :only => [:show_psets, :assign_pset, :show]
  before_filter :validate_classroom, :only => [:show, :show_psets, :assign_pset, :assign_quiz]
  
  def show
    if @classroom.teacher_id == 
  end

  def show_psets
    @sg_psets = ProblemSet.master_sets
    @my_psets = current_user.problem_sets
    @assigned_problem_sets = @classroom.assigned_problem_sets
    respond_to do |format|
      format.html
    end
  end

  def show_quizzes
  end

  ## GET /assign_pset, remote => true
  def assign_pset
    if @classroom.classroom_teachers.pluck(:teacher_id).include? current_user.id
      @pset = ProblemSet.find(params[:pset_id])
      @classroom.assign!(@pset)
      render :js => "window.location.href = '/'"
    else
      render :js => 'alert("this class doesn\'t belong to you!");'
    end
  end

  def assign_quiz
    unless @classroom.teacher == current_user
      render :js => 'alert("this class doesn\'t belong to you!");'
    end

    @quiz = Quiz.find(params[:quiz_id])
    @classroom.assign!(@quiz)
    render :js => "window.location.href = '/'"
  end

  def new
    @classroom = Classroom.new
    respond_to do |format|
      format.js
    end
  end

  def create
    @classroom = Classroom.create(params[:classroom])
    respond_to do |format|
      if @classroom.save
        @classroom.classroom_teachers.create(:teacher_id => @teacher.id)
        format.html { redirect_to root_path, notice: 'Classroom was successfully created.' }
      else
        format.js { render action: "new" }
      end
    end
  end

  def join
    respond_to do |format|
      format.js
    end
  end

  def join_class
    @classroom = Classroom.find_by_teacher_password(params[:class_teacher_pass])
    @join_class = @teacher.classrooms.find_by_id(@classroom.id)
    @join_class ||= @teacher.classroom_teachers.create(:classroom_id => @classroom.id) unless @classroom.nil?

    respond_to do |format|
      if @join_class
        format.html { redirect_to root_path, notice: 'Classroom joined successfully' }
      else
        format.html { redirect_to root_path, notice: 'No classrooms found successfully' }
      end
    end
  end

  private
  
  def teacher?
    deny_access unless current_user.is_a?(Teacher)
  end

  def validate_teacher
    @teacher = Teacher.find_by_id(params[:id])
  end

  def validate_teacher_via_current_user
    @teacher = current_user if current_user.is_a? Teacher
  end

  def validate_classroom
    @classroom = Classroom.find_by_id(params[:id])
  end
end