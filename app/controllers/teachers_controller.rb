class TeachersController < ApplicationController
  def home
    @classrooms = current_user.classrooms.includes(:students).includes(:problem_sets)
    @quiz_history = []
  end

  # GET /details/:classroom_id ... that should be changed if we make changing the class ajax
  # if you change classes the URL won't get changed currently
  def student
  end
end
