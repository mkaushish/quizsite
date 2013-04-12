class TeachersController < ApplicationController
  def home
    @classrooms = current_user.classrooms.includes(:students).includes(:problem_sets)
    @quiz_history = []
  end

  def create
    teacher = Teacher.new params[:teacher]
    if !teacher.save
      render :js => form_for_errs('teacher', teacher)
      return
    end

    classroom = teacher.classrooms.new params[:classroom]
    if !classroom.save
      teacher.delete
      render :js => form_for_errs('classroom', classroom)
      # TODO display errors on form
    end

    sign_in teacher
    render :js => "window.location.href = '/'"
  end

  # GET /details/:classroom_id ... that should be changed if we make changing the class ajax
  # if you change classes the URL won't get changed currently
  def student
  end
end
