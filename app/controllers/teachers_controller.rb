class TeachersController < ApplicationController
  # GET /details/:classroom_id ... that should be changed if we make changing the class ajax
  # if you change classes the URL won't get changed currently
  def details
    @teacher_nav_elts = 'details'

    @classroom = params[:classroom_id].nil? ? current_user.classrooms.first : Classroom.find(params[:classroom_id])
    @students  = @classroom.students
    @concepts = []

    @classrooms = current_user.classrooms.includes(:problem_sets)
    @problem_sets = @classroom.problem_sets
    @problem_set = @problem_sets.first

    @quiz_history = @classroom.quizzes

    @stat_calc = TeacherStatCalc.new(@students, @problem_set.problem_types)
  end

  # POST AJAX
  def details_classroom
    if params["classroom_id"].empty?
      @classroom = Classroom.new
    else
      @classroom = current_user.classrooms.where(:id => params[:classroom_id].to_s).includes(:problem_sets).first
    end

    @problem_sets = @classroom.problem_sets
  end

  # POST AJAX
  def details_problem_set
    @problem_set = ProblemSet.find params["problem_set_id"].to_s
    @classroom = Classroom.find params["classroom_id"].to_s

    @problem_types = @problem_set.problem_types
    @students = @classroom.students

    @quiz_history = @classroom.quizzes

    @stat_calc = TeacherStatCalc.new(@students, @problem_types)
  end

  def student
  end

  def home
    @classrooms = current_user.classrooms.includes(:students).includes(:problem_sets)
    @quiz_history = []
  end

  private
end
