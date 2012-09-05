class CustomProblemsController < ApplicationController
  before_filter :authenticate, :except => [:show]

  # GET /custom_problems
  # GET /custom_problems.json
  def index
    @custom_problems = CustomProblem.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @custom_problems }
    end
  end

  # GET /custom_problems/1
  # GET /custom_problems/1.json
  def show
    @problem = CustomProblem.find(params[:id])
    render 'problemanswers/new'
  end

  # GET /custom_problems/new
  # GET /custom_problems/new.json
  def new
    @custom_problem = CustomProblem.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @custom_problem }
    end
  end

  # GET /custom_problems/1/edit
  def edit
    @custom_problem = CustomProblem.find(params[:id])
  end

  # POST /custom_problems
  # POST /custom_problems.json
  def create
    puts params
    @problem = make_custom_prob_from_params
    puts @problem.inspect
    @custom_problem = current_user.custom_problems.new(:chapter => params[:chapter], :problem => @problem, :name => params[:name])

    respond_to do |format|
      if @custom_problem.save
        format.html { redirect_to @custom_problem, notice: 'Custom problem was successfully created.' }
        format.json { render json: @custom_problem, status: :created, location: @custom_problem }
      else
        format.html { render action: "new" }
        format.json { render json: @custom_problem.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /custom_problems/1
  # PUT /custom_problems/1.json
  def update
    @prob = prototype
    @custom_problem = CustomProblem.find(params[:id])

    render :nothing => true
    #respond_to do |format|
    #  if @custom_problem.update_attributes(params[:custom_problem])
    #    format.html { redirect_to @custom_problem, notice: 'Custom problem was successfully updated.' }
    #    format.json { head :ok }
    #  else
    #    format.html { render action: "edit" }
    #    format.json { render json: @custom_problem.errors, status: :unprocessable_entity }
    #  end
    #end
  end

  # DELETE /custom_problems/1
  # DELETE /custom_problems/1.json
  def destroy
    @custom_problem = CustomProblem.find(params[:id])
    @custom_problem.destroy

    respond_to do |format|
      format.html { redirect_to custom_problems_url }
      format.json { head :ok }
    end
  end

  private

  def make_custom_prob_from_params
    if params[:response] == 'number'
      return CustomQuestionNum.new(params[:problem_text], params[:answer_number])

    elsif params[:response] == 'text'
      return CustomQuestionText.new(params[:problem_text], params[:answer_text])

    elsif params[:response] == 'multiplechoice'
      resps = [ params[:answer_mcq] ]

      params.each_key do |key|
        resps << params[key] if key =~ /answer_choice/
      end

      return CustomQuestionMCQ.new(params[:problem_text], resps)

    else 
      return nil
    end
  end
end
