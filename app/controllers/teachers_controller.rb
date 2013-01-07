class TeachersController < ApplicationController
  def details
    @classroom = params[:classroom_id].nil? ? current_user.classrooms.first : Classroom.find(params[:classroom_id])
    @students  = @classroom.students
    @concepts = []

    @classrooms = current_user.classrooms.includes(:problem_sets)
    @classroom = Classroom.new
    @problem_sets = []
  end

  # POST
  def details_classroom
    if params["classroom_id"].empty?
      @classroom = Classroom.new
    else
      @classroom = current_user.classrooms.where(:id => params[:classroom_id].to_s).includes(:problem_sets).first
      $stderr.puts @classroom.inspect
    end

    @problem_sets = @classroom.problem_sets
  end

  def details_problem_set
  end

  def student
  end

  def home
    @classrooms = current_user.classrooms.includes(:students).includes(:problem_sets)
  end
end
