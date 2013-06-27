class DetailsController < ApplicationController

    def details
        @teacher_nav_elts = 'details'
        @classroom = Classroom.find(params[:id])
        @students  = @classroom.students
        @classrooms = current_user.classrooms.includes(:problem_sets)
        @problem_sets = @classroom.problem_sets
        @problem_set = params[:problem_set_id].nil? ? @problem_sets.first : ProblemSet.find(params[:problem_set_id])
        @quiz_history = @problem_set.nil? ? []:@classroom.quizzes.where(problem_set_id: @problem_set.id)
        @stat_calc = TeacherStatCalc.new(@students, @problem_set.problem_types)
    end

    # POST /details/select_classroom AJAX
    def select_classroom
        if params["classroom_id"].empty?
            @classroom = Classroom.new
        else
            @classroom = current_user.classrooms.where(:id => params[:classroom_id]).includes(:problem_sets).first
        end
        @problem_sets = @classroom.problem_sets
        @problem_set = @problem_sets.first
    end

    # POST /details/select_problem_set AJAX
    def select_problem_set
        @problem_set = ProblemSet.find params["problem_set_id"]
        @classroom = Classroom.find params["ps_classroom_id"]
        @problem_types = @problem_set.problem_types
        @students = @classroom.students
        @quiz_history = @classroom.quizzes
        @stat_calc = TeacherStatCalc.new(@students, @problem_types)
    end

    # POST /details/click_concept AJAX
    def click_concept
        @classroom = Classroom.find params[:classroom]
        @students = @classroom.students
        @problem_type = ProblemType.find params[:problem_type]
        @student_stats = ProblemStat.where(problem_type_id: @problem_type.id, user_id: @students.map(&:id)).includes(:user).sort { |a,b| a.user.name <=> b.user.name }
    end
end
