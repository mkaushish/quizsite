class BadgesController < ApplicationController
  before_filter :validate_student
  
  def show
  @badges = @student.badges
    
  end
  
  private     
  # before filter for validating student
  def validate_student
    @student = current_user
  end