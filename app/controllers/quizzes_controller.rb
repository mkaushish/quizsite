class QuizzesController < ApplicationController

    include TeachersHelper
    before_filter :authenticate, except: [:show, :do]
    before_filter :validate_teacher, only: [:index, :new, :create]
    before_filter :validate_teacher_via_current_user, except: [:index, :new, :create]

    def index
        @quizzes = @teacher.quizzes
        respond_to do |format|
            format.html
        end
    end

    def show
        @quiz = @teacher.quizzes.find_by_id(params[:id])    
        @quiz_problems = @quiz.quiz_problems.includes(:problem)
        if defined? params[:classroom_id] and !params[:classroom_id].blank?
            @classroom = Classroom.find_by_id(params[:classroom_id])
            @students = @classroom.students
            @student_ids = @students.pluck(:student_id)
            @quiz_result = @classroom.quiz_results(@quiz.id)
        end
        respond_to do |format|
            format.html
        end
    end

    def new
        @problem_set    = ProblemSet.includes(:problem_types).find_by_id(params[:pset])
        @problem_types  = @problem_set.problem_types
        
        @quiz           = @teacher.quizzes.build(problem_set_id: @problem_set.id)
        @quiz_problems  = @quiz.quiz_problems.build
    end
    
    def create
        @quiz                   = @teacher.quizzes.build(params[:quizzes])
        @quiz.name              = params[:quiz][:name]
        @quiz.problem_set_id    = params[:quiz][:problem_set_id]
        @quiz_type              = params[:quiz_type] if defined? params[:quiz_type] and !params[:quiz_type].blank?
        if @quiz.save
            if @quiz_type == "Single Classroom"
                @classroom = Classroom.find_by_id(params[:classroom_id]) if defined? params[:classroom_id] and !params[:classroom_id].blank?
                @quiz.assign_classroom(@classroom) unless @classroom.blank?

            elsif @quiz_type == "Multiple Classrooms"
                @quiz.assign_classrooms(params[:classroom_ids]) if defined? params[:classroom_ids] and !params[:classroom_ids].blank?

            elsif @quiz_type == "Specific Students"
                if defined? params[:student_ids] and !params[:student_ids].blank?
                    @quiz.assign_students(params[:student_ids], params[:classroom_id])
                end
            end
            @params_quiz_problem        = params[:quiz_problems] if defined? params[:quiz_problems]
            unless @params_quiz_problem.blank?
                @problems               = @params_quiz_problem.select{ |v| v == "problem"}.first.last 
                @problem_categories     = @params_quiz_problem.select{ |v| v == "problem_category"}.first.last
                @problem_type_ids       = @params_quiz_problem.select{ |v| v == "problem_type_id"}.first.last
                @problems_count         = @problems.count
                @problems_count.times.each_with_index do | v, index | 
                    @quiz_problem       = @quiz.quiz_problems.create(:problem_id => @problems[index], :problem_type_id => @problem_type_ids[index], :problem_category => @problem_categories[index])
                end
            end
            redirect_to root_path, notice: "Quiz Created Successfully"
        else
            render :action => 'new'
        end
    end

    def quiz_answers
        @quiz_instance = QuizInstance.find_by_id(params[:quiz_instance])
        @answers = @quiz_instance.answers.where("user_id = ? ", params[:student_id])
        respond_to do |format|
            format.js
        end
    end

    def set_type
        @classrooms = @teacher.classrooms
        @quiz_id = params[:quiz_id] if defined? params[:quiz_id]
        if defined? params[:aqt]
            case params[:aqt]
                when "Single Classroom"
                    @quiz_type      = "Single Classroom"
                    @classroom_id   = params[:classroom_id] if defined? params[:classroom_id]
                    @classroom      = Classroom.find_by_id(@classroom_id) unless @classroom_id.blank?
                    unless @quiz_id.blank?
                        unless @classroom.blank?
                            @quiz = Quiz.find_by_id(@quiz_id)
                            @quiz.assign_classroom(@classroom)
                            @assigned = "true"
                        end
                    end

                when "Multiple Classrooms"
                    @quiz_type      = "Multiple Classrooms"
                    @classroom_ids  = params[:classroom_ids] if defined? params[:classroom_ids]
                    @classrooms     = Classroom.where(:id => @classroom_ids) unless @classroom_ids.blank?
                    debugger
                    unless @quiz_id.blank?
                        unless @classroom_ids.blank? 
                            @quiz = Quiz.find_by_id(@quiz_id)
                            @quiz.assign_classrooms(@classroom_ids)
                            @assigned = "true"
                        end
                    end

                when "Specific Students"
                    @quiz_type      = "Specific Students"
                    if defined? params[:classroom_id]
                        @classroom      = Classroom.find_by_id(params[:classroom_id])
                        @students       = @classroom.students unless defined? params[:student_ids] and @classroom.blank?
                        @student_ids    = params[:student_ids] if defined? params[:student_ids]
                        @students       = Student.where(:id => @student_ids) unless @student_ids.blank?
                        unless @quiz_id.blank?
                            unless @classroom.blank? 
                                unless @student_ids.blank?
                                    @quiz = Quiz.find_by_id(@quiz_id)
                                    @quiz.assign_students(@student_ids, params[:classroom_id])
                                    @assigned = "true"
                                end
                            end
                        end
                    end
            end
        end
        respond_to do |format|
            format.js
        end
    end

    def assign
        @quiz = Quiz.find_by_id(params[:id]) if defined? params[:id]
        respond_to do |format|
            format.js
        end
    end
    # change the problem types in a quiz
    # def edit
    #     @classroom = current_user.classrooms.find_by_name params[:classroom]
    #     @problem_set = ProblemSet.find(params[:pset])
    #     @quiz = Classroom.quizzes.where(problem_set_id: @problem_set.id)
    #     @quiz_problems = @quiz.quiz_problems.includes(:problem_type)
    # end

    private

    # def is_owner(quiz)
    #     quiz.user_id == current_user.id
    # end

    # def params_to_problemtype_ids
    #     p_ptypes = params[:problem_types]
    #     p_ptypes.nil? ? [] : p_ptypes.keys.map { |e| e.to_i }
    # end

    # def get_quizprobs_from_params(params)
    #     quiz_problems = []
    #     all_probs.each do |prob|
    #         if params[prob.to_s] == "1"
    #             quiz_problems << prob
    #         end
    #     end
    #     return nil if quiz_problems.empty? # so validation fails
    #     return Marshal.dump(quiz_problems)
    # end

    def validate_teacher_via_current_user
        @teacher = current_user
    end

    def validate_teacher
        @teacher = Teacher.find_by_id(params[:teacher_id])
    end
end