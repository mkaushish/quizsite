class StudentsController < ApplicationController
  before_filter :authenticate, :except => [:show, :new, :create]

  def home
    @student = current_user
    @pset_instances = @student.problem_set_instances.includes(:problem_set)
    
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
    sign_in student
    render :js => "window.location.href = '/'"
  end

  def edit
    @student = current_user
  end

   def update
    @student = Student.find_by_id(params[:id])
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
  end
end
