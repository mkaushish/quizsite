class StudentsController < ApplicationController
    
    before_filter :authenticate, :except => [:show, :new, :create]
    before_filter :validate_student, :only => [:update, :show, :chart, :badges, :notifications, :progress, :quizzes, :get_problem_set_history, :get_problem_type_history]
    before_filter :validate_student_via_current_user, :only => [:home, :edit]

    def home
        @pset_instances         = @student.problem_set_instances.order("problem_set_id ASC").includes(:problem_set)
        @classroom              = @student.classrooms.first
        @active_problem_set_ids = @classroom.classroom_problem_sets.only_active.pluck(:problem_set_id)
        @history                = @student.answers.limit(11).includes(:problem_type).order("created_at DESC")
        @pset_instances         = @pset_instances.select {|v| @active_problem_set_ids.include? v.problem_set_id }
        
        # @all_badges = @student.all_badges
    end
    
    def badges
        @shape = params[:shape]
        @student_badges = @student.badges.where("level = ?", @shape) 
        @all_badges = @student.all_badges.select{ |v| v[2] == @shape.to_i }
        respond_to do |format|
            format.html
            format.js
        end
    end
    
    def notifications
        @notifications = @student.news_feeds.order("created_at DESC").limit(10).pluck(:content)
        respond_to do |format|
            format.js
        end
    end
    
    def show
        if current_user.is_a? Teacher
            @problem_sets = @student.problem_sets.order("id ASC").includes(:problem_types)
            @merit = @student.merits_simple.first
            respond_to do |format|
                format.js
            end
        elsif @student == current_user
            respond_to do |format|
                format.html
            end
        else
            redirect_to student_badges_path(@student.id) and return
        end
    end

    def progress
        @problem_sets = @student.problem_sets.order("id ASC").includes(:problem_types)
        @tab = 'progress'
    end

    def quizzes
        @quizzes = @student.all_quizzes_without_problemset
        respond_to do |format|
            format.html
        end
    end

    def edit
        respond_to do |format|
            format.js
        end
    end

    def update
        @old_pass = params['student']['old_password']
        @new_pass = params['student']['new_password']
        @confirm_pass = params['student']['confirm_password']
        @student.change_password(@old_pass, @new_pass, @confirm_pass)
        sign_in @student
        respond_to do |format|
            if @student.update_attributes(params[:student])
                format.html { redirect_to studenthome_path, notice: 'Your Profile is successfully updated.' }
            else
                format.html { render action: "edit" }
            end
        end
    end

    def me
    end

    def chart
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
    
    def problemset_chart
        @problem_set = ProblemSet.find_by_id(params[:pset])
        @chart_data_1 = @problem_set.chart_percentage_of_correct_answers_by_problem_set
        @chart_data_2 = @problem_set.chart_percentage_of_wrong_answers_by_problem_set
        respond_to do |format|
            format.js 
        end 
    end

    def get_problem_set_history
        @problem_set = @student.problem_sets.includes(:problem_types).find_by_id(params[:problem_set_id])
        @problem_set_history = @problem_set.history(@student.id)
        respond_to do |format|
            format.js
        end
    end

    def get_problem_type_history
        @problem_type = ProblemType.find_by_id(params[:problem_type_id])
        @answers = @problem_type.answers.where("user_id = ?", @student.id)
        respond_to do |format|
            format.js
        end
    end
    # def new
    #     @student = Student.new
    # end

    # def create
    #     student = Student.new(params[:student])
    #     if !student.save
    #         $stderr.puts "STUDENT_ERRORS\n\t\t#{student.errors.full_messages.inspect}"
    #         $stderr.puts "FORM_FOR_ERRS:" + form_for_errs('student', student)
    #         render :js => form_for_errs('student', student)
    #         return
    #     end
    #     classroom = nil
    #     if params[:class_pass].empty?
    #         classroom = Classroom.smarter_grades
    #     else
    #         classroom = Classroom.find_by_student_password(params[:class_pass])
    #     end
    #     if classroom.nil?
    #         student.delete
    #         render :js => form_err_js(:class_pass, "Invalid class password")
    #         return
    #     end
    #     classroom.assign!(student)
    #     #UserMailer.welcome_email(student).deliver
    #     sign_in student
    #     render :js => "window.location.href = '/'"
    # end

    private

    def validate_student
       @student = Student.find_by_id(params[:id])
    end

    def validate_student_via_current_user
        @student = current_user
    end
end