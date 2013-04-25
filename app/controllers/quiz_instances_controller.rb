class QuizInstancesController < ApplicationController
  # GET /quizs/:name
  # quizs_path(:name)
  def show
    @quiz = Quiz.find(params[:name])
    @instance = QuizInstance.where(:quiz_id => @quiz.id,
                                   :user_id => current_user.id).first
    @instance ||= current_user.quiz_instances.new(:quiz => @quiz)
    @stats = @instance.stats
    @sessions = []
    include_history @quiz
  end

  def do
    # @quiz = Quiz.find(params[:name])
    # @instance = QuizInstance.where(:quiz_id => @quiz.id,
    #                                :user_id => current_user.id).first
    # # @instance ||= current_user.quiz_instances.new(:quiz => @quiz)
    # redirect_to access_denied_path && return if @instance.nil?

    # if @quiz.problem_types.exists? params[:pid]
    #   @problem_type = @quiz.problem_types.find(params[:pid])
    #   @stat = @instance.stat(@problem_type)
    #   @problem = @stat.spawn_problem
    # else
    #   redirect_to access_denied_path && return
    # end
  end

  def problem_results
  end

  # POST /quizs/:name/finish_problem
  # ps_finish_problem_path(:name)
  def finish_problem
    @stat =     QuizStat.includes(:quiz_instance).find(params[:stat_id])
    redirect_to access_denied_path && return if @stat.user != current_user

    @instance = @stat.quiz_instance
    @answer = current_user.answers.create params: params, session: @instance
    @stat.update!(@answer)

    redirect_to quizs_path(@instance.quiz_id)
  end

  private
  # 
  # Sets the @history variable, which allows the partial 'quizs/_history' to be rendered
  #
  def include_history(quiz, n = 11)
    return nil if current_user.nil?

    #instance = @instance || QuizInstance.where(:quiz_id => @quiz.id,
    #                                                 :user_id => current_user.id).first
    #stats = (@stats || @instance.stats).map(&:id)
    generators = ProblemGenerator.where(:problem_type_id => quiz.problem_types.map(&:id)).map(&:id)
    @history = current_user.answers.where(:problem_generator_id => generators)
                            .order("created_at DESC")
                            .includes(:problem)
                            .limit(n)
  end
end
