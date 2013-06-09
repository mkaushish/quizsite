class QuizzesController < ApplicationController
  include TeachersHelper
  before_filter :authenticate, :except => [:show, :do]

  # display PScores for the problem types / quiz ?
  def show
  end

  # choose the problems for a quiz
  def new
    @classroom = Classroom.find(params[:classroom])
    @problem_set = ProblemSet.find(params[:pset])
    @quiz = @classroom.quizzes.create(problem_set: @problem_set)
    $stderr.puts "QUIZ: #{@quiz.inspect}"
    #if defined? params[:ptype]
     # @new_quiz_problem = @quiz.quiz_problems.new(problem_type: params[:ptype], count: 1)
      #@new_quiz_problem.save
      #$stderr.puts "QUIZPROBS: #{@quiz_problems.inspect} #{params}"
    #end
    #@quiz_problems = @quiz.quiz_problems
    $stderr.puts "QUIZPROBS: #{@quiz_problems.inspect} #{params}"
  end

  # change the problem types in a quiz
  def edit
    @classroom = current_user.classrooms.find_by_name params[:classroom]
    @problem_set = ProblemSet.find(params[:pset])
    @quiz = Classroom.quizzes.where(problem_set_id: @problem_set.id)
    @quiz_problems = @quiz.quiz_problems.includes(:problem_type)
  end

  def partial_create

    @classroom = Classroom.find params[:classroom]
    @quiz = @classroom.quizzes.find_by_id(params[:quiz])  
    #@quiz = @classroom.quizzes.find_by_id(params[:quiz]) 
    
    @quiz_problem = @quiz.quiz_problems.create problem_type_id: params[:ptype], partial: true
    
    redirect_to edit_quiz_problem_path(@quiz_problem, :id => @quiz_problem.id)
    # respond_to do |format|
    #   format.js
    # end
  end

  # POST /quiz
  # quiz problems come in in theformat of 
  def create
    debugger
    @classroom = Classroom.find params[:classroom_id]

    quiz_problems_attributes = []
    params[:quiz_problems].each_pair do |k, v|
      quiz_problems_attributes << {problem_type_id: k, problem_category: v, partial: nil} 
    end

    @quiz = @classroom.quizzes.create problem_set_id: params[:problem_set_id],
    quiz_problems_attributes: quiz_problems_attributes
 



    $stderr.puts "ERRORS "*10
    $stderr.puts @classroom.id
    $stderr.puts params[:problem_set_id]
    $stderr.puts quiz_problems_attributes.to_s
    $stderr.puts @quiz.errors.full_messages

    if params[:students]
      @students = User.where(:id => params[:students].keys)
    else
      @students = @classroom.students
    end

     respond_to do |format|
      format.js
     end
  end

  # ROUTE: post :classroom/assign_quiz/:id, assign_quiz_path(id:, classroom:)
  def assign
    @quiz = Quiz.find params[:id]
    @classroom = Classroom.find params[:classroom]
    @class_quiz = @quiz.for_class @classroom

    @class_quiz.assign params[:start_time], params[:end_time]
    @class_quiz.save
  end

  # DELETE /quizzes/1
  def destroy

  end


  private

  def is_owner(quiz)
    quiz.user_id == current_user.id
  end

  def params_to_problemtype_ids
    p_ptypes = params[:problem_types]
    p_ptypes.nil? ? [] : p_ptypes.keys.map { |e| e.to_i }
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
