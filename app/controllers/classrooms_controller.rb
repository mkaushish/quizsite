class ClassroomsController < ApplicationController
  before_filter :teacher?, :except => [:show]

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
