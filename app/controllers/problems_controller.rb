class ProblemsController < ApplicationController
  include ProblemHelper

  def index
    @chapters = ProblemSet
    @custom_problems = signed_in? && current_user.problem_types
  end

  def show
    @problem = Problem.find(params[:id])

    @solution = @problem.solve
    @response = @solution
    @answer = Answer.new(:problem => @problem)
    
    render 'answers/show'
  end

  def new # CREATES A NEW CUSTOM PROBLEM
    @custom_problem = Problem.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @custom_problem }
    end
  end

  def create
    @qb_problem = make_custom_prob_from_params
    puts @qb_problem.inspect

    @problem_type = current_user.problem_types.new(:klass => @qb_problem.class, 
                                                   :name => params[:name] )
    pt_save = @problem_type.save

    @custom_problem = @problem_type.problems.new(:problem => @qb_problem)
    cp_save = @custom_problem.save

    respond_to do |format|
      if cp_save && pt_save 
        format.html { redirect_to @custom_problem, notice: 'Custom problem was successfully created.' }
        format.json { render json: @custom_problem, status: :created, location: @custom_problem }
      else
        format.html { render action: "new" }
        format.json { render json: @custom_problem.errors, status: :unprocessable_entity }
      end
    end
  end

  # GET /problems/:ID/example
  # where :ID is the ProblemType index
  def example # GIVES YOU AN EXAMPLE PROBLEM OF PTYPE
    @problem_type = ProblemType.find(params[:id])

    if signed_in?
      @spawner = current_user.problem_stat(@problem_type)
    else
      @spawner = @problem_type
    end

    @problem = @spanwer.spawn_problem
    render
  end

  def make_custom_prob_from_params
    if params[:response] == 'number'
      return CustomProblemNum.new(params[:name], params[:problem_text], params[:answer_number])

    elsif params[:response] == 'text'
      return CustomProblemText.new(params[:name], params[:problem_text], params[:answer_text])

    elsif params[:response] == 'multiplechoice'
      resps = [ params[:answer_mcq] ]

      params.each_key do |key|
        resps << params[key] if key =~ /answer_choice/
      end

      return CustomProblemMCQ.new(params[:name], params[:problem_text], resps)

    else 
      return nil
    end
  end
end
