class TeachersController < ApplicationController
  def home
    @classrooms = current_user.classrooms.includes(:students).includes(:problem_sets)
    @quiz_history = []
  end

  def create
    teacher = Teacher.new(
      name: params[:name],
      email: params[:email],
      password: params[:password],
      password_confirmation: params[:password_confirmation]
    )
    if !teacher.save
      # TODO display errors on form
    end

    class1 = teacher.classrooms.new name: params[:class_name]
    if !class1.save
      teacher.delete
      # TODO display errors on form
    end

    sign_in teacher
    redirect_to teacherhome_path
  end

  # GET /details/:classroom_id ... that should be changed if we make changing the class ajax
  # if you change classes the URL won't get changed currently
  def student
  end
end
