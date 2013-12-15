class ClassroomsController < ApplicationController

    before_filter :authenticate
    before_filter :teacher?, :except => [:show]
    before_filter :validate_teacher, :only => [:new, :create, :join, :join_class]
    before_filter :validate_teacher_via_current_user, :only => [:show_psets, :assign_pset]
    before_filter :validate_classroom, :only => [:show, :show_psets, :assign_pset, :assign_quiz]

    def show
        @topics = @classroom.topics.includes(:user)
        @topic = Topic.new
        #@comments = @classroom.comments.includes(:user).order("created_at DESC")
        #@comment = Comment.new
        if current_user.is_a? Student and current_user.classrooms.include? @classroom
            @student = current_user
            @activities = @classroom.activities
        elsif current_user.is_a? Teacher
            @teacher = current_user
            if @classroom.teacher_id == @teacher.id or @classroom.classroom_teachers.pluck(:teacher_id).include? @teacher.id
                @activities = @classroom.activities
            else
                redirect_to root_path, notice: "This class doesn't belongs to you!"
            end
        else
            redirect_to root_path, notice: "This class doesn't belongs to you!"
        end
    end

    def show_psets
        @sg_psets = ProblemSet.master_sets
        @my_psets = current_user.problem_sets
        @assigned_problem_sets = @classroom.assigned_problem_sets
        respond_to do |format|
            format.html
        end
    end

    def show_quizzes
    end

    ## GET /assign_pset, remote => true
    def assign_pset
        if @classroom.classroom_teachers.pluck(:teacher_id).include? current_user.id
            @pset = ProblemSet.find(params[:pset_id])
            @classroom.assign!(@pset)
            @assigned_problem_sets = @classroom.assigned_problem_sets
            respond_to do |format|
                format.js
            end
        else
            render :js => 'alert("this class doesn\'t belong to you!");'
        end
    end

    def show_problem_sets
        @classroom = Classroom.find_by_id(params[:classroom_id])
        @classroom_problem_sets = @classroom.classroom_problem_sets.includes(:problem_set)
        respond_to do |format|
            format.html
        end
    end

    def toggle_classroom_problem_set
        @classroom = Classroom.find_by_id(params[:classroom_id])
        @classroom_problem_set = @classroom.classroom_problem_sets.find_by_id(params[:id])
        op = { true => false, false => true }
        @classroom_problem_set.update_attributes(active: op[@classroom_problem_set.active?]) unless @classroom_problem_set.blank?
        respond_to do |format|
            format.js
        end
    end

    def assign_quiz
        unless @classroom.teacher == current_user
            render :js => 'alert("this class doesn\'t belong to you!");'
        end
        @quiz = Quiz.find(params[:quiz_id])
        @classroom.assign!(@quiz)
        render :js => "window.location.href = '/'"
    end

    def new
        @classroom = Classroom.new
        respond_to do |format|
            format.js
        end
    end

    def create
        @classroom = Classroom.create(params[:classroom])
        respond_to do |format|
            if @classroom.save
                @classroom.classroom_teachers.create(:teacher_id => @teacher.id)
                format.html { redirect_to root_path, notice: 'Classroom was successfully created.' }
            else
                format.js { render action: "new" }
            end
        end
    end

    def join_class
        debugger
        @classroom = Classroom.find_by_teacher_password(params[:class_teacher_pass])
        unless @classroom.blank?
            @join_class = @teacher.classrooms.find_by_id(@classroom.id) 
            @join_class ||= @teacher.classroom_teachers.find_by_classroom_id(@classroom.id)
            @join_class ||= @teacher.classroom_teachers.create(:classroom_id => @classroom.id)
        end
        respond_to do |format|
            unless @join_class.blank?
                format.html { redirect_to root_path, notice: 'Classroom joined successfully' }
            else
                format.html { redirect_to root_path, notice: 'No classrooms found successfully' }
            end
        end
    end

    private

    def teacher?
        deny_access unless current_user.is_a?(Teacher)
    end

    def validate_teacher
        @teacher = Teacher.find_by_id(params[:id])
    end

    def validate_teacher_via_current_user
        @teacher = current_user if current_user.is_a? Teacher
    end

    def validate_classroom
        @classroom = Classroom.find_by_id(params[:id])
    end
end