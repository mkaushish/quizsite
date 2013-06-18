class QuizInstancesController < ApplicationController
  
  before_filter :authenticate
  before_filter :validate_student
  # GET quizzes/:id/start
  # start_quiz_path(@quiz)
  def start
    @title = "Starting Quiz"
    @instance = QuizInstance.find(params[:id])

    deny_access && return unless @instance.user_id == current_user.id
    return finish_quiz if @instance.over?
    @quiz = Quiz.find_by_id(@instance.quiz_id)
    @counter = @quiz.quiz_problems.count - @instance.stats_remaining.count
    @instance.start
    next_problem
  end

  def new
    @pset_instance = ProblemSetInstance.find(params[:id])
    deny_access && return unless belongs_to_user(@pset_instance)

    @classroom = @student.classrooms.first

    @quiz = @classroom.quizzes.first
    @instance = QuizInstance.where(:quiz_id => @quiz.id, 
                                   :problem_set_instance_id => @pset_instance.id).first
    @instance ||= @quiz.assign_with_pset_inst(@pset_instance)
    @instance.start if !@instance.started?
    @counter = @quiz.quiz_problems.count - @instance.stats_remaining.count
    @quiz_stats = @instance.quiz_stats.includes(:problem_type)
    @pset = @instance.problem_set
    next_problem
  end

  
  # GET /quizzes/:id/next_quiz_problem
  # next_quiz_problem_path
  def previous_problem
   @instance ||= QuizInstance.includes(:problem_set).find(params[:id])
    deny_access && return unless @instance.user_id == current_user.id
    return finish_quiz if @instance.over?

    @answer = @instance.answers.where("correct = false AND problem_id = params[:problem_id]")
    @problem = @answer.first.problem


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
    @quiz_stats = @instance.quiz_stats.includes(:problem_type)
    @pset = @instance.problem_set
    respond_to do |format|
      format.html { render 'problem' }
      format.js { render 'do' }
    end
  end

  def finish_quiz
    @title = "Quiz Results"
    @instance ||= QuizInstance.find(params[:id])
    @instance.finish
    @pset = @instance.problem_set
    @answers = @instance.answers.includes(:problem_type)
    render 'results'
    
  end


  # POST /quiz/:id/finish_problem
  def finish_problem

    @stat = QuizStat.includes(:quiz_instance).find(params[:stat_id])
    redirect_to access_denied_path && return if @stat.user != current_user

    @instance = @stat.quiz_instance
    @quiz = Quiz.find_by_id(@instance.quiz_id)

    @answer = current_user.answers.create params: params, session: @instance
    @stat.update_w_ans!(@answer)
    @counter = @quiz.quiz_problems.count - @instance.stats_remaining.count
    @pset = @instance.problem_set
    
    if @instance.over?
      finish_quiz
    else
      next_problem
    end
  end

  private
  def validate_student
    @student = current_user
  end

end
