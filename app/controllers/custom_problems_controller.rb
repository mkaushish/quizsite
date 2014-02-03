class CustomProblemsController < ApplicationController
	before_filter :authenticate
	#  before_filter :authenticate_admin
	before_filter :validate_custom_problem, :only => [:edit, :update]
	before_filter :validate_teacher
	
	def index
		@chapters = ProblemSet.master_sets_with_ptypes
		@custom_problems = @teacher.custom_problems.order("created_at DESC")
		respond_to do |format|
			format.html
		end
	end


	def new
		@problem_type = ProblemType.find_by_id(params[:problem_type_id])
		@custom_problem = @teacher.custom_problems.build
		respond_to do |format|
			format.js
		end
	end

	# GET /custom_problems/1/edit
	def edit
	end

	# POST /custom_problems
	def create
		@problem_type = ProblemType.find(params["problem_type_id"])
		@problem_generator = @problem_type.custom_problems_generator
		@problem = make_custom_prob_from_params

		@custom_problem = @teacher.custom_problems.build(
			:problem => @problem,
			:user_id => @teacher.id,
			:body => params[:problem_body],
			:explanation => params[:problem_explanation]
		)

		if @custom_problem.save
			flash[:custom_problem_created] = @custom_problem
			respond_to do |format|
				format.js
			end
		else
			flash[:errors] = @custom_problem.errors.full_messages
			render 'form_errors'
		end
	end

	# PUT /custom_problems/1
	# PUT /custom_problems/1.json
	def update
		@custom_problem = Problem.find_by_id(params[:id])
		@problem_type = ProblemType.find_by_name(@custom_problem.to_s)
		@problem_generator = @problem_type.custom_problems_generator
		@problem = make_custom_prob_from_params
		@custom_problem.problem = @problem
		@custom_problem.user_id = @teacher.id
		@custom_problem.body = params[:problem_body]
		@custom_problem.explanation = params[:problem_explanation]
		respond_to do |format|
		 if @custom_problem.save
			 format.html { redirect_to teacher_custom_problems_path(@teacher), notice: 'Custom problem was successfully updated.' }
		 else
			 format.html { render action: "edit" }
		 end
		end
	end

	# DELETE /custom_problems/1
	# DELETE /custom_problems/1.json
	def destroy
		@custom_problems = @teacher.custom_problems
		@custom_problem = @teacher.custom_problems.find_by_id(params[:id])
		@custom_problem.destroy

		respond_to do |format|
			format.html { redirect_to teacher_custom_problems_path(@teacher) }
			format.json { head :ok }
			format.js
		end
	end

	def import
  		Problem.import(params[:file])
  		redirect_to teacher_custom_problems_path(@teacher), notice: "Custom Problems Imported."
	end

	private

	def make_custom_prob_from_params
		name = @problem_type ? @problem_type.name : ProblemType.find(params[:problem_type_id]).name

		if params[:response] == 'text'
			return CustomProblemText.new(name, params[:problem_text], params[:text_correct])

		elsif params[:response] == 'multiplechoice'
			resps = [ params[:mcq_correct] ]
			6.times do |i|
				key = "mcq_#{i}"
				resps << params[key] if !params[key].nil? && !params[key].empty?
			end

			return CustomProblemMCQ.new(name, params[:problem_text], resps)
		end
		nil
	end

	def validate_custom_problem
		@custom_problem = Problem.find_by_id(params[:id])
	end
	def validate_teacher
		@teacher = Teacher.find_by_id(params[:teacher_id])
	end
end
