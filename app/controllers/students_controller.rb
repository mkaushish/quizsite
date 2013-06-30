class StudentsController < ApplicationController
    
    before_filter :authenticate, :except => [:show, :new, :create]

    def home
        @student = current_user
        @pset_instances = @student.problem_set_instances
                              .includes(:problem_stats, :problem_set, :problem_set_problems)
        @history = current_user.answers.order("created_at DESC").limit(11)
        @is_all_blue = @student.badges.where(:name=> "BadgeAPSD").blank?
        Student.create_badges(@student)
        @badges = @student.badges
    end

    def new
        @student = Student.new
    end

    def create
        student = Student.new(params[:student])
        if !student.save
            $stderr.puts "STUDENT_ERRORS\n\t\t#{student.errors.full_messages.inspect}"
            $stderr.puts "FORM_FOR_ERRS:" + form_for_errs('student', student)
            render :js => form_for_errs('student', student)
            return
        end
        classroom = nil
        if params[:class_pass].empty?
            classroom = Classroom.smarter_grades
        else
            classroom = Classroom.find_by_password(params[:class_pass])
        end
        if classroom.nil?
            student.delete
            render :js => form_err_js(:class_pass, "Invalid class password")
            return
        end
        classroom.assign!(student)
        UserMailer.welcome_email(student).deliver
        sign_in student
        render :js => "window.location.href = '/'"
    end

    def edit
        @student = current_user
        respond_to do |format|
            format.js
        end
    end

    def update
        @student = Student.find_by_id(params[:id])
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

    def show
        @student = Student.find_by_id(params[:id])
    end
end