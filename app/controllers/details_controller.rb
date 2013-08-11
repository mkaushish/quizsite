class DetailsController < ApplicationController

    before_filter :authenticate
    before_filter :validate_classroom, :except => [:select_classroom]
    before_filter :validate_teacher_via_current_user

    def details
        @teacher_nav_elts = 'details'
        @classrooms = @teacher.classrooms
        @students  = @classroom.students
        @chart_data_1 = @classroom.chart_over_all_students_answer_stats
        if defined? params[:type]
            case params[:type]
                when 'students'
                    respond_to do |format|
                        format.js
                    end
                when 'problem_sets'
                    @problem_sets = @classroom.problem_sets
                    @problem_set = params[:problem_set_id].nil? ? @problem_sets.first : ProblemSet.find_by_id(params[:problem_set_id])
                    @stat_calc = TeacherStatCalc.new(@students, @problem_set.problem_types)
                    @chart_data_2 = @classroom.chart_percentage_of_students_answers_correct_by_problem_sets_with_intervals(@problem_set)
                    @chart_data_3 = @problem_set.chart_classroom_problem_set_problem_types_students_percentage_correct
                    respond_to do |format|
                        format.js
                    end
                when 'quizzes'
                    @problem_sets = @classroom.problem_sets
                    @classroom_quizzes = @classroom.quizzes
                    @problem_set = params[:problem_set_id].nil? ? @problem_sets.first : ProblemSet.find_by_id(params[:problem_set_id])
                    respond_to do |format|
                        format.js
                    end
                when 'grades'
                    @problem_sets = @classroom.problem_sets
                    @problem_set = params[:problem_set_id].nil? ? @problem_sets.first : ProblemSet.find_by_id(params[:problem_set_id])
                    @problem_types = @problem_set.problem_types
                    @start_date = params[:start_date].nil? ? (Time.now-(365*24*60*60)) : params[:start_date]
                    @end_date = params[:end_date].nil? ? (Time.now) : params[:end_date]
                    respond_to do |format|
                        format.js
                    end
            end
        end
    end

    def download_grades
        @problem_sets = @classroom.problem_sets
        @students = @classroom.students
        @problem_set = params[:problem_set_id].nil? ? @problem_sets.first : ProblemSet.find_by_id(params[:problem_set_id])
        @problem_types = @problem_set.problem_types
        @start_date = params[:start_date].nil? ? (Time.now-(365*24*60*60)) : params[:start_date]
        @end_date = params[:end_date].nil? ? (Time.now) : params[:end_date]
        respond_to do |format|
            format.csv
            format.xls
        end
    end

    # POST /details/select_classroom AJAX
    def select_classroom
        if params["classroom_id"].empty?
            @classroom = Classroom.new
        else
            @classroom = @teacher.classrooms.includes(:problem_sets).find_by_id(params[:classroom_id])
        end
        @problem_sets = @classroom.problem_sets
        @problem_set = @problem_sets.first
        respond_to do |format|
            format.html { redirect_to details_path(@classroom.id)}
        end
    end

    # POST /details/select_problem_set AJAX
    def select_problem_set
        @problem_set = ProblemSet.find params["problem_set_id"]
        @classroom = Classroom.find params["ps_classroom_id"]
        @problem_types = @problem_set.problem_types
        @students = @classroom.students
        @quiz_history = @classroom.quizzes
        @stat_calc = TeacherStatCalc.new(@students, @problem_types)
        @start_date=params[:start_date].to_time
        @end_date=params[:end_date].to_time
    end

    def select_dates
        @problem_set = ProblemSet.find_by_id(params[:problem_set_id])
        @start_date=params[:start_date].to_time
        @end_date=params[:end_date].to_time
        @problem_types = @problem_set.problem_types
        @students = @classroom.students
    end

    # POST /details/click_concept AJAX
    def click_concept
        @classroom = Classroom.find params[:classroom]
        @students = @classroom.students
        @problem_type = ProblemType.find params[:problem_type]
        @student_stats = ProblemStat.where(problem_type_id: @problem_type.id, user_id: @students.map(&:id)).includes(:user).sort { |a,b| a.user.name <=> b.user.name }
    end

    private
    def validate_classroom
        @classroom = Classroom.includes(:problem_sets).find(params[:classroom])
    end

    def validate_teacher_via_current_user
        @teacher = current_user
    end
end

