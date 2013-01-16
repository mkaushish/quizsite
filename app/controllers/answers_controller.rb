require 'c1'
require 'c2'
require 'c3'
require 'c6'
require 'c7'
require 'physics'

class AnswersController < ApplicationController
  # GET /answers
  # GET /answers.json
  def index
    @answers = current_user.answers

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @answers }
    end
  end

  # GET /answers/1
  # GET /answers/1.json
  def show
    stop_quiz if params[:quizid] == "-1"
    @answer = Answer.find(params[:id])
    @problem = @answer.problem.problem
    @solution = @problem.prefix_solve
    puts "^"*60
    puts @solution.inspect
    @response = @answer.response_hash

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @answer }
    end
  end

  # GET /answers/new
  # GET /answers/new.json
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
      @last_prob = Answer.find(flash[:last_id])
    end

    $stderr.puts "rendering: #{@problem.inspect}"
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @answer }
    end
  end

  # GET /answers/1/edit
  def edit
    @answer = Answer.find(params[:id])
  end

  def explain
    @bigproblem = Problem.find(params["problem_id"])
    if @bigproblem.is_a? QuestionWithExplanation
      @subproblems = @bigproblem.explain
    end
  end

  # POST /answers
  # POST /answers.json
  def create
    $stderr.puts "_" * 100 + "\n" + session[:return_to]
    @problem = Problem.find(params["problem_id"])

    time = params["time_taken"].to_f
    last_correct = @problem.correct?(params)
    notepad = (params["npstr"].empty?) ? nil : params["npstr"] # in case it's the empty string 

    flash[:last_correct] = last_correct

    if signed_in?
      @answer = current_user.answers.new(
                          :problem  => @problem,
                          :time_taken => time,
                          :correct  => last_correct,
                          :response => @problem.get_packed_response(params),
                          :notepad => notepad )
    else
      @answer = Answer.new(
                        :problem  => @problem,
                        :time_taken => time,
                        :correct  => last_correct,
                        :response => @problem.get_packed_response(params))
    end

    if @answer.save
      flash[:last_id] = @answer.id
      redirect_to session[:return_to]
    else
      adderror("Had some trouble saving the last response")
      redirect_to root_path
    end
  end

  # PUT /answers/1
  # PUT /answers/1.json
  def update
    @answer = Answer.find(params[:id])

    respond_to do |format|
      if @answer.update_attributes(params[:answer])
        format.html { redirect_to @answer, notice: 'Answer was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @answer.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /answers/1
  # DELETE /answers/1.json
  def destroy
    @answer = Answer.find(params[:id])
    @answer.destroy

    respond_to do |format|
      format.html { redirect_to answers_url }
      format.json { head :ok }
    end
  end
end
