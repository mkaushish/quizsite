class QuizzesController < ApplicationController
  include TeachersHelper
  before_filter :authenticate, :except => [:show]

  # display PScores for the problem types / quiz ?
  def show
  end

  # choose the problems for a quiz
  def new
    stop_quiz
    @nav_selected = "makequiz"
    @chosen_probs = get_probs
    @chapter = Chapter1
  end

  # change the problem types in a quiz
  def edit
    @nav_selected = "makequiz"
    @quiz = Quiz.find(params[:id])

    unless @quiz.user_id == current_user.id
      deny_access
    end
    set_quiz @quiz
    @chosen_probs = get_probs
    @chapter = Chapter1
  end

  # POST /quiz
  def create
    if current_user.is_a?(Teacher)
      @quiz = current_user.homeworks.new(
        :problemtypes => get_quizprobs_from_params(params),
        :name => params["quiz_name"]
      )
    elsif current_user.is_a?(Student)
      @quiz = current_user.practice_sets.new(
        :problemtypes => get_quizprobs_from_params(params),
        :name => params["quiz_name"]
      )
    else
      render :js => "window.location = '/'"
    end

    if @quiz.save
      if current_user.is_a? Teacher
        classrooms.each do |classroom|
          classroom.assign!(@quiz) if(params["class_#{classroom.id}"])
        end
      else
        set_quiz(@quiz)
      end

      render :js => "window.location = '/profile'"
    else
      $stderr.puts "#"*60
      $stderr.puts "COULDN'T SAVE: #{@quiz.errors.full_messages}"

      @errors = @quiz.errors
      respond_to { |format| format.js }
    end
  end

  # PUT /quiz/:id
  def update
    @quiz = Quiz.find(params[:id])
    unless is_owner(@quiz)
      adderror "You can only edit your own quizzes!"
      redirect_to profile_path
    end

    @quiz.problemtypes = get_quizprobs_from_params(params)

    if @quiz.save
      redirect_to profile_path
    else
      adderror("couldn't save the quiz for some reason... need to get better error messages")
      redirect_to profile_path
    end
  end

  # DELETE /quizzes/1
  def destroy
    @quiz = Quiz.find(params[:id])
    unless is_owner(@quiz)
      adderror "You can only edit your own quizzes!"
      redirect_to profile_path
    end

    @quiz.destroy
    if current_user.quizzes.empty?
      render :js => "window.location = '/profile'"
    else
      respond_to { |format| format.js }
    end
  end

  private

  def is_owner(quiz)
    quiz.user_id == current_user.id
  end

  def get_quizprobs_from_params(params)
    quiz_problems = []
    all_probs.each do |prob|
      if params[prob.to_s] == "1"
        quiz_problems << prob
      end
    end
    return nil if quiz_problems.empty? # so validation fails
    return Marshal.dump(quiz_problems)
  end
end
