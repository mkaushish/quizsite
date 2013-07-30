class CoachesController < ApplicationController
  
    before_filter :authenticate, :except => [:create]
    before_filter :validate_coach, :only => [:edit, :update, :add_student]
    before_filter :validate_coach_via_current_user, :only => [:home, :search_students, :create]

    def home
        @students = @coach.students
    end
    
    # GET /coaches/new
    # GET /coaches/new.json
    def new
        @coach = Coach.new
        respond_to do |format|
            format.html # new.html.erb
        end
    end

    # GET /coaches/1/edit
    def edit
        respond_to do |format|
            format.js
        end
    end

    # POST /coaches
    # POST /coaches.json
    def create
        @coach = Coach.new(params[:coach])
        if @coach.save
            sign_in @coach
            render :js => "window.location.href = '/'"
        else    
            render action: "new" 
        end
    end

    # PUT /coaches/1
    # PUT /coaches/1.json
    def update
        @old_pass = params['coach']['old_password']
        @new_pass = params['coach']['new_password']
        @confirm_pass = params['coach']['confirm_password']
        @coach.change_password(@old_pass, @new_pass, @confirm_pass)
        sign_in @coach
        respond_to do |format|
            if @coach.update_attributes(params[:coach])
                format.html { redirect_to coachhome_path, notice: 'Coach was successfully updated.' }
            else
                format.html { render action: "edit" }
            end
        end
    end

    def search_students
        @search = Student.ransack(params[:q]) 
        @students_searched = @search.result(:distinct => true) 
        @total_students = @students_searched.count
    end
    
    def add_student
        @student = Student.find_by_id(params[:student])
        @coach_rel = @coach.relationships.find_by_student_id(@student.id)
        @coach_rel ||= @coach.relationships.create(:student_id => @student.id, :relation => params[:relation])
        redirect_to coachhome_path
    end

    private

    def validate_coach
        @coach = Coach.find_by_id(params[:id])
    end

    def validate_coach_via_current_user
        @coach = current_user
    end
end