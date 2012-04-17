class QuizzesController < ApplicationController
  # display PScores for the problem types / quiz ?
  def show
  end

  # choose the problems for a quiz
  def new
    @nav_selected = "makequiz"
    @chosen_probs = get_probs
    @chapter = CricketQuestions
  end

  # change the problem types in a quiz
  def edit
    @nav_selected = "makequiz"
    @quiz = Quiz.find(params[:id])
    set_quiz @quiz
    @chosen_probs = get_probs
    @chapter = CricketQuestions
  end

  # POST /quiz
  def create
    quiz_problems = []
    all_probs.each do |prob|
      if params[prob.to_s] == "1"
        quiz_problems << prob
      end
    end

    @quiz = current_user.quizzes.new(
      :problemtypes => Marshal.dump(quiz_problems),
      :name => params["quiz_name"]
    )

    set_probs(quiz_problems)
    if @quiz.save
      redirect_to profile_path
    else
      $stderr.puts "#"*60
      $stderr.puts "COULDN'T SAVE: #{@quiz.errors}"
      adderror("couldn't save the last quiz: #{@quiz.errors.inspect}")
      redirect_to profile_path
    end
  end

  # PUT /quiz/:id
  def update
    @quiz = Quiz.find(params[:id])
    unless @quiz.user == current_user
      adderror "You can only edit your own quizzes!"
      redirect_to profile_path
    end
    
    quiz_problems = []
    all_probs.each do |prob|
      if params[prob.to_s] == "1"
        quiz_problems << prob
      end
    end

    @quiz.problemtypes = Marshal.dump(quiz_problems)
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
end
