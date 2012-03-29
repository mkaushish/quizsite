class QuizController < ApplicationController
  # display PScores for the problem types / quiz ?
  def show
  end

  # choose the problems for a quiz
  def new
  end

  # change the problem types in a quiz
  def edit
  end

  # POST /quiz
  def create
    $stderr.puts params.inspect

    quiz_problems = []
    all_probs.each do |prob|
      if params[prob.to_s] == "1"
        quiz_problems << prob
      end
    end

    @quiz = current_user.quizzes.new(
      :problemtypes = Marshal.dump(quiz_problems)
    )

    set_probs(quiz_problems)
    #flash[:notice] = "you just set your problems"
    redirect_to quiz_path
  end

  # PUT /quiz/:id
  def update
  end

  # DELETE /quizzes/1
  def destroy
  end
end
