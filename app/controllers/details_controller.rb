class DetailsController < ApplicationController

    before_filter :authenticate
    before_filter :validate_classroom, :except => [:select_classroom]
    before_filter :validate_teacher_via_current_user

    def details 
        @teacher_nav_elts = 'details'
        @classrooms = @teacher.classrooms
        @students  = @classroom.students
        
        if defined? params[:type]
            case params[:type]
                when 'students'
                    @student = params[:student_id].nil? ? @students.first : @students.find_by_id(params[:student_id])
                    unless @student.blank?
                        charts_data = @student.charts_combine
                        @chart_data_1 = charts_data[0]
                        @chart_data_2 = charts_data[1]
                        @chart_data_3 = charts_data[2]
                        @chart_data_4 = charts_data[3]
                        @chart_data_5 = charts_data[4]
                        @chart_data_6 = charts_data[5]
                        @chart_data_7 = charts_data[6]
                        @chart_data_8 = charts_data[7]
                    end
                when 'problem_sets'
                    @problem_sets = @classroom.problem_sets.order("id ASC")
                    @problem_set = params[:problem_set_id].nil? ? @problem_sets.first : ProblemSet.find_by_id(params[:problem_set_id])
                    unless @problem_set.blank?
                        @stat_calc = TeacherStatCalc.new(@students, @problem_set.problem_types) 
                        @chart_data_2 = @classroom.chart_percentage_of_students_answers_correct_by_problem_sets_with_intervals(@problem_set)
                        @chart_data_3 = @problem_set.chart_classroom_problem_set_problem_types_students_percentage_correct
                    end
                    
                when 'quizzes'
                    @problem_sets = @classroom.problem_sets.order("id ASC")
                    @classroom_quizzes = @classroom.classroom_quizzes.includes(:quiz)
                    @problem_set = params[:problem_set_id].nil? ? @problem_sets.first : ProblemSet.find_by_id(params[:problem_set_id])
                    @quiz_history = Array.new
                    @classroom_quizzes.each do |classroom_quiz|
                        @quiz_history.push classroom_quiz.quiz if classroom_quiz.quiz.problem_set_id == @problem_set.id
                    end
                    
                when 'grades'
                    @problem_sets = @classroom.problem_sets.order("id ASC")
                    @problem_set = params[:problem_set_id].nil? ? @problem_sets.first : ProblemSet.find_by_id(params[:problem_set_id])
                    unless @problem_set.blank?
                        @problem_types = @problem_set.problem_types
                        @start_date = params[:start_date].nil? ? (Time.now-(365*24*60*60)) : params[:start_date]
                        @end_date = params[:end_date].nil? ? (Time.now) : params[:end_date]
                    end

                # when 'discussions'
                #     @topics = @classroom.topics.includes(:user)
                #     @topic = Topic.new
                when 'discussions'
                    @topics = @classroom.topics.includes(:user)
                    @topic = Topic.new
                when 'lessons'
                    @lessons = @classroom.lessons.includes(:teacher)
                when 'psets'
                    @classroom_problem_sets = @classroom.classroom_problem_sets.includes(:problem_set).select{|v| v.problem_set.user_id == nil}
                    @my_problem_sets = @classroom.classroom_problem_sets.includes(:problem_set).select{|v| v.problem_set.user_id == @teacher.id}
                else
                    @chart_data_1 = @classroom.chart_over_all_students_answer_stats(nil, nil)
                    @top_weak_students = @classroom.weak_students(5, nil, nil)
                    @lesson = @classroom.lessons.where("end_time IS ?", nil).first
                    @classroom_problem_sets = @classroom.classroom_problem_sets.includes(:problem_set).only_active
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
        @start_date = params[:start_date].to_time
        @end_date = params[:end_date].to_time
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
