class QuizzesController < ApplicationController
  before_filter :authenticate, :except => [:show]
  # display PScores for the problem types / quiz ?
  def show
  end

  # choose the problems for a quiz
  def new
    stop_quiz
    @nav_selected = "makequiz"
    @chosen_probs = get_probs
    @chapter = CricketQuestions
  end

  # change the problem types in a quiz
  def edit
    @nav_selected = "makequiz"
    @quiz = Quiz.find(params[:id])

    unless @quiz.identifiable == current_user.identifiable
      deny_access
    set_quiz @quiz
    @chosen_probs = get_probs
    @chapter = CricketQuestions
  end

  # POST /quiz
  def create
    @quiz = current_user.quiz_type.new(
      :identifiable => current_user.identifiable,
      :problemtypes => get_quizprobs_from_params(params),
      :name => params["quiz_name"]
    )

    if @quiz.save
      set_quiz(@quiz)
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
    unless @quiz.user == current_user
      adderror "You can only edit your own quizzes!"
      redirect_to profile_path
    end

    dumped_quiz_problems = get_quizprobs_from_params(params)

    @quiz.problemtypes = dumped_quiz_problems
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
    @quiz_id = @quiz.idname

    @quiz.destroy
    if current_user.quizzes.empty?
      render :js => "window.location = '/profile'"
    else
      respond_to { |format| format.js }
    end
  end

  private

  def verify_user(quiz)
    quiz.identifiable == current_user.identifiable
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
