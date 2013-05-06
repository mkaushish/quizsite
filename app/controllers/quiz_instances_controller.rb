class QuizInstancesController < ApplicationController
  # GET quizzes/:id/start
  # start_quiz_path(@quiz)
  def start
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
    @instance.start

    next_problem
  end

  # GET /quizzes/:id/next_quiz_problem
  # next_quiz_problem_path
  def next_problem
    @instance ||= QuizInstance.includes(:problem_set).find(params[:id])
    deny_access && return unless @instance.user_id == current_user.id

    @stat = @instance.next_stat
    @problem_type = @stat.problem_type
    @problem = @stat.spawn_problem

    respond_to do |format|
      format.html { render 'problem' }
      format.js { render 'do' }
    end
  end

  def do
    @quiz = Quiz.first
    @instance = QuizInstance.where(:quiz_id => @quiz.id,
                                    :user_id => current_user.id).first
    @instance ||= current_user.quiz_instances.new(:quiz => @quiz)
    redirect_to access_denied_path && return if @instance.nil?
    
    @problem_set = ProblemSet.find_by_id(params[:pid])
    @problem_type = @quiz.problem_types
    @problem = Problem.last
     #if @quiz.problem_types.exists? params[:pid]
     #   @problem_type = @quiz.problem_types.find(params[:pid])
     #   @stat = @instance.stat(@problem_type)
     #   @problem = @stat.spawn_problem
     #else
     #   redirect_to access_denied_path && return
     # end
  end

  def finish_quiz
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
    #@answer = current_user.answers.create params: params, session: @instance
    @stat.update!(@answer)

    if @instance.over?
      finish_quiz
    else
      next_problem
    end
  end
end
