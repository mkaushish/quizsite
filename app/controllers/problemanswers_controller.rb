require 'c1'
require 'c2'
require 'c3'
require 'c6'
require 'c7'
require 'physics'

class ProblemanswersController < ApplicationController
  # GET /problemanswers
  # GET /problemanswers.json
  def index
    @problemanswers = current_user.problemanswers

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @problemanswers }
    end
  end

  # GET /problemanswers/1
  # GET /problemanswers/1.json
  def show
    stop_quiz if params[:quizid] == "-1"
    @problemanswer = Problemanswer.find(params[:id])
    @problem = @problemanswer.problem.problem
    @solution = @problem.prefix_solve
    puts "^"*60
    puts @solution.inspect
    @response = @problemanswer.response_hash

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @problemanswer }
    end
  end

  # GET /problemanswers/new
  # GET /problemanswers/new.json
  def new
    if !params[:quizid].nil?
      quiz = Quiz.find(params[:quizid])
      unless quiz.nil?
        set_quiz quiz
      end
    end

    if in_examples?
      @problem = Problem.create(:ptype => example_type)
      $stderr.puts "in examples: #{@problem.inspect}"
      render 'new' && return
    end

    unless signed_in? && in_quiz?
      $stderr.puts "#{'!'*100} redirecting to root_path"
      redirect_to root_path && return 
    end

    if quiz_user.force_explanation?
      redirect_to(:controller => :problem, :action => :explain, :id => quiz_user.problem_id)
      return
    end

    @problem = next_problem
    @nav_selected = "quiz"

    #$stderr.puts "#"*30 + "\n" + @problem.problem.text.inspect

    unless flash[:last_correct] || flash[:last_id].nil?
      @last_prob = Problemanswer.find(flash[:last_id])
    end

    $stderr.puts "rendering: #{@problem.inspect}"
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @problemanswer }
    end
  end

  # GET /problemanswers/1/edit
  def edit
    @problemanswer = Problemanswer.find(params[:id])
  end

  def explain
    @bigproblem = Problem.find(params["problem_id"])
    if @bigproblem.is_a? QuestionWithExplanation
      @subproblems = @bigproblem.explain
    end
  end

  # POST /problemanswers
  # POST /problemanswers.json
  def create
    @problem = Problem.find(params["problem_id"])

    time = params["time_taken"].to_f
    last_correct = @problem.correct?(params)
    notepad = (params["npstr"].empty?) ? nil : params["npstr"] # in case it's the empty string 

    flash[:last_correct] = last_correct

    if signed_in?
      @problemanswer = current_user.problemanswers.new(
                          :problem  => @problem,
                          :time_taken => time,
                          :correct  => last_correct,
                          :response => @problem.get_packed_response(params),
                          :notepad => notepad )

      #$stderr.puts "\n\n#{"#"*30}\n#{@problem.text}"
      #$stderr.puts "#{@problem.problem.solve}"
      #$stderr.puts "params = #{params.inspect}\n#{"#"*30}\n"

      if @problemanswer.save
        flash[:last_id] = @problemanswer.id
        increment_problem(last_correct)

        if last_correct
          redirect_to :action => 'new'
        else
          if in_quiz? && quiz_user.force_explanation?
            redirect_to explain_path(quiz_user.problem_id)
          else
            redirect_to @problemanswer
          end
        end
      else
        adderror("Had some trouble saving the last response")
        redirect_to :action => 'new'
      end
    else
      # not signed in, no user
      @problemanswer = Problemanswer.new(
                        :problem  => @problem,
                        :time_taken => time,
                        :correct  => last_correct,
                        :response => @problem.get_packed_response(params))
      # seems this line must be repeated
      flash[:last_id] = @problemanswer.id
      if @problemanswer.save
        redirect_to @problemanswer
      else
        redirect_to problems_path
      end
    end
  end

  # PUT /problemanswers/1
  # PUT /problemanswers/1.json
  def update
    @problemanswer = Problemanswer.find(params[:id])

    respond_to do |format|
      if @problemanswer.update_attributes(params[:problemanswer])
        format.html { redirect_to @problemanswer, notice: 'Problemanswer was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @problemanswer.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /problemanswers/1
  # DELETE /problemanswers/1.json
  def destroy
    @problemanswer = Problemanswer.find(params[:id])
    @problemanswer.destroy

    respond_to do |format|
      format.html { redirect_to problemanswers_url }
      format.json { head :ok }
    end
  end
end
