class BadgesController < ApplicationController
	
	before_filter :authenticate
	before_filter :validate_student, only: [:show]
	before_filter :validate_teacher, only: [:new, :create]

	def show
		@badges = @student.badges
	end

	def new
		@badge = Badge.new
		@comment_id = params[:comment_id] 	if defined? params[:comment_id]
		@answer_id 	= params[:answer_id] 	if defined? params[:answer_id]
		@student_id = params[:student_id] 	if defined? params[:student_id]
		respond_to do |format|
			format.js
		end
	end

	def create
		@badge = @teacher.merits_given.build(params[:badge])
		respond_to do |format|
  			if @badge.save
    			format.js
  			else
    			format.html { redirect_to "#", notice: "Merit isn't Created!" }
  			end
    	end
	end

	private     
	# before filter for validating student
	def validate_student
		@student = current_user
	end

	def validate_teacher
		@teacher = Teacher.find_by_id(params[:teacher_id])
	end
end