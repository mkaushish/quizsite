class ClassroomsController < ApplicationController
  before_filter :teacher?, :except => [:show]

  def show
  end

  def new
    @classroom = teacher.classrooms.new
  end

  def create
  end

  def edit
  end

  private
  
  def teacher?
    deny_access unless teacher
  end
end
