class LessonsController < ApplicationController
    
    before_filter :validate_classroom, except: [:destroy]
  
    def index
        @teacher = current_user
        @lessons = @classroom.lessons.includes(:teacher)
    end
    
    def show
        @teacher = current_user
        @lesson = @classroom.lessons.find_by_id(params[:id])
        if defined? @lesson and !@lesson.blank?
            @start_time = @lesson.start_time - (5.hours + 30.minutes)
            @end_time = @lesson.end_time - (5.hours + 30.minutes)
        end
        if params[:type] == "definite"
            @chart_data_1 = @classroom.chart_over_all_students_answer_stats(@start_time, @end_time)
            @top_weak_students = @classroom.weak_students(5, @start_time, @end_time)
        else
            @chart_data_1 = @classroom.chart_over_all_students_answer_stats(nil, nil)
            @top_weak_students = @classroom.weak_students(5, nil, nil)
        end
        respond_to do |format|
            format.html
            format.js
        end
    end

    # GET /lessons/new
    # GET /lessons/new.json
    def new
        @lesson = @classroom.lessons.build
        respond_to do |format|
            format.js
        end
    end

    # POST /lessons
    # POST /lessons.json
    def create
        @lesson = @classroom.lessons.build(params[:lesson])
        respond_to do |format|
            if @lesson.save
                format.html {redirect_to details_path(@classroom.id), notice: "Session created Successfully!"}
            else
                format.html { render action: "new" }
                format.json { render json: @lesson.errors, status: :unprocessable_entity }
            end
        end
    end

    # DELETE /lessons/1
    # DELETE /lessons/1.json
    def destroy
        @lesson = Lesson.find(params[:id])
        @lesson.destroy
        respond_to do |format|
            format.html { redirect_to lessons_url }
            format.json { head :no_content }
        end
    end

    private

    def validate_classroom
        @classroom = Classroom.find_by_id(params[:classroom_id])
    end
end