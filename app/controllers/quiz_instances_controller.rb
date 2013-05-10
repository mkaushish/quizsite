class QuizInstancesController < ApplicationController
  # GET quizzes/:id/start
  # start_quiz_path(@quiz)
  def start
    @title = "Starting Quiz"
    @instance = QuizInstance.find(params[:id])

    deny_access && return unless @instance.user_id == current_user.id
    return finish_quiz if @instance.over?

    @instance.start
    next_problem
  end

  def new
    @pset_instance = ProblemSetInstance.find(params[:id])
    deny_access && return unless belongs_to_user(@pset_instance)

    @quiz = @pset_instance.problem_set.default_quiz
    @instance = QuizInstance.where(:quiz_id => @quiz.id, 
                                   :problem_set_instance_id => @pset_instance.id).first
    @instance ||= @quiz.assign_with_pset_inst(@pset_instance)
    @instance.start if !@instance.started?

    next_problem
  end

  
  # GET /quizzes/:id/next_quiz_problem
  # next_quiz_problem_path
  def previous_problem
    @instance ||= QuizInstance.includes(:problem_set).find(params[:id])
    deny_access && return unless @instance.user_id == current_user.id
    return finish_quiz if @instance.over?

    @stat = @instance
    @problem_type = @stat.problem_type
    @problem = @stat.spawn_problem

    respond_to do |format|
      format.html { render 'problem' }
      format.js { render 'do' }
    end
  end


  # GET /quizzes/:id/next_quiz_problem
  # next_quiz_problem_path
  def next_problem
    @title ||= "In Quiz"
    @instance ||= QuizInstance.includes(:problem_set).find(params[:id])
    deny_access && return unless @instance.user_id == current_user.id
    return finish_quiz if @instance.over?

    @stat = @instance.next_stat
    @problem_type = @stat.problem_type
    @problem = @stat.spawn_problem

    respond_to do |format|
      format.html { render 'problem' }
      format.js { render 'do' }
    end
  end

  def finish_quiz
    @title = "Quiz Results"
    @instance ||= QuizInstance.find(params[:id])

    @instance.finish

    @answers = @instance.answers.includes(:problem_type)

    render 'results'
  end

  # POST /quiz/:id/finish_problem
  def finish_problem
    @stat = QuizStat.includes(:quiz_instance).find(params[:stat_id])
    redirect_to access_denied_path && return if @stat.user != current_user

    @instance = @stat.quiz_instance
    @answer = current_user.answers.create params: params, session: @instance
    @stat.update_w_ans!(@answer)

    if @instance.over?
      finish_quiz
    else
      next_problem
    end
  end
end
