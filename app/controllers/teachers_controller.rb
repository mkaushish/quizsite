class TeachersController < ApplicationController
    
    before_filter :validate_teacher, :only => [:edit, :update]
    before_filter :validate_teacher_via_current_user, :only => [:home, :student]

    def home
        @classrooms = @teacher.classrooms.paginate(:page => params[:page], :per_page => 5)
        @quiz_history = []
    end

    def create
        teacher = Teacher.new params[:teacher]
        if !teacher.save
            render :js => form_for_errs('teacher', teacher)
            return
        end
        classroom = Classroom.new params[:classroom]
        if classroom.save
            classroom_teacher = teacher.classroom_teachers.create(:classroom_id => classroom.id)
        else
            teacher.delete
            render :js => form_for_errs('classroom', classroom)
            return
        end
        sign_in teacher
        render :js => "window.location.href = '/'"
    end

    def edit
        respond_to do |format|
            format.js
        end
    end

    def update
        @old_pass = params['teacher']['old_password']
        @new_pass = params['teacher']['new_password']
        @confirm_pass = params['teacher']['confirm_password']
        @teacher.change_password(@old_pass, @new_pass, @confirm_pass)
        sign_in @teacher
        respond_to do |format|
            if @teacher.update_attributes(params[:teacher])
                format.html { redirect_to root_path, notice: 'Your Profile is successfully updated.' }
            else
                format.html { render action: "edit" }
            end
        end
    end

    # GET /details/:classroom_id ... that should be changed if we make changing the class ajax
    # if you change classes the URL won't get changed currently
    def student
    end

    private

    def validate_teacher
        @teacher = Teacher.find_by_id(params[:id])
    end

    def validate_teacher_via_current_user
        @teacher = current_user
    end
end