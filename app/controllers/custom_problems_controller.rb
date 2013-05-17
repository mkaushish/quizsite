class CustomProblemsController < ApplicationController
  before_filter :authenticate

  def new
    @chapters = ProblemSet.master_sets_with_ptypes
    @created_problems = current_user.custom_problems.order("created_at DESC")
    render 'select_problem_type'
  end

  # GET /custom_problems/1/edit
  def edit
    @custom_problem = current_user.custom_problems.find_by_id(params[:id])
    
  end

  # POST /custom_problems
  def create
    @problem_type = ProblemType.find(params["problem_type_id"])
    @problem_generator = @problem_type.custom_problems_generator
    @problem = make_custom_prob_from_params

    @custom_problem = current_user.custom_problems.new(
      :problem => @problem,
      :user_id => current_user.id
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
    
    @custom_problem = current_user.custom_problems.find_by_id(params[:id])

    respond_to do |format|
     if @custom_problem.update_attributes(params[:custom_problem])
       format.html { redirect_to @custom_problem, notice: 'Custom problem was successfully updated.' }
       format.json { head :ok }
     else
       format.html { render action: "edit" }
       format.json { render json: @custom_problem.errors, status: :unprocessable_entity }
     end
    end
  end

  # DELETE /custom_problems/1
  # DELETE /custom_problems/1.json
  def destroy
    @custom_problem = current_user.custom_problems.find_by_id(params[:id])
    @custom_problem.destroy

    respond_to do |format|
      format.html { redirect_to new_custom_problem_path }
      format.json { head :ok }
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
end
