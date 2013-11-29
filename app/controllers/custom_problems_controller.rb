class CustomProblemsController < ApplicationController
  before_filter :authenticate
  before_filter :authenticate_admin
  before_filter :validate_custom_problem, :only => [:edit, :update]
  
  def new
    @chapters = ProblemSet.master_sets_with_ptypes
    @custom_problems = current_user.custom_problems.order("created_at DESC")
    render 'select_problem_type'
  end

  # GET /custom_problems/1/edit
  def edit
  end

  # POST /custom_problems
  def create
    @problem_type = ProblemType.find(params["problem_type_id"])
    @problem_generator = @problem_type.custom_problems_generator
    @problem = make_custom_prob_from_params

    @custom_problem = current_user.custom_problems.new(
      :problem => @problem,
      :user_id => current_user.id,
      :body => params[:problem_body],
      :explanation => params[:problem_explanation]
    )

    if @custom_problem.save
      flash[:custom_problem_created] = @custom_problem
      render 'close_problem'
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
    @custom_problem.user_id = current_user.id
    @custom_problem.body = params[:problem_body]
    @custom_problem.explanation = params[:problem_explanation]
    respond_to do |format|
     if @custom_problem.save
       format.html { redirect_to new_custom_problem_path, notice: 'Custom problem was successfully updated.' }
     else
       format.html { render action: "edit" }
     end
    end
  end

  # DELETE /custom_problems/1
  # DELETE /custom_problems/1.json
  def destroy
    @custom_problems = current_user.custom_problems
    @custom_problem = current_user.custom_problems.find_by_id(params[:id])
    @custom_problem.destroy

    respond_to do |format|
      format.html { redirect_to new_custom_problem_path }
      format.json { head :ok }
      format.js
    end
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
end
