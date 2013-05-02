class QuizInstancesController < ApplicationController
  # GET quizzes/:id/start
  # start_quiz_path(@quiz)
  def start
    @instance = QuizInstance.find(params[:id])
    deny_access && return unless @instance.user_id == current_user.id

    @instance.start
    redirect_to next_problem_path(@instance)
  end

  # GET /quizzes/:id/next_problem
  # next_quiz_problem_path
  def next_problem
    @instance = QuizInstance.find(params[:id])
    deny_access && return unless @instance.user_id == current_user.id

    @stat = @instance.next_stat
    @problem_type = @stat.problem_type
    @problem = @stat.spawn_problem
  end

  def finish_problem
    redirect_to next_problem
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

  def results
  end

  # POST /quizs/:name/finish_problem
  # ps_finish_problem_path(:name)
  def finish_problem
    @stat = QuizStat.includes(:quiz_instance).find(params[:stat_id])
    redirect_to access_denied_path && return if @stat.user != current_user

    @instance = @stat.quiz_instance
    #@answer = current_user.answers.create params: params, session: @instance
    @stat.update!(@answer)

    redirect_to quizs_path(@instance.quiz_id)
  end
end
