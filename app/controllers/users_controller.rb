class UsersController < ApplicationController
  before_filter :authenticate, :only => [:show]

  def new
    @user = User.new
  end
  
  # POST confirm
  def confirm
    @user = User.find params['id']

    if @user.confirmed?
      # were confirmed before this shit...
      redirect_to root_path

    elsif @user.confirm(params['code'])
      @user.save( :validate => false )
      sign_in @user
      redirect_to profile_path

    else
      render 'confirmation_error'
    end
  end

  # PROFILE PAGE FOR STUDENTS/TEACHERS/PARENTS
  def profile
    @title = "Profile"
    @nav_selected = "profile"


    if current_user.is_a?(Student)
      stop_quiz
      render 'students/profile'

    elsif current_user.is_a?(Teacher)
      redirect_to :stats
    end
  end

  def stats
    @title = "Stats"
    @nav_selected = "stats"

    if current_user.is_a?(Teacher)
      @classroom = Classroom.find params[:id]
      @students  = @classroom.students
      render 'teachers/stats'
    else
      redirect_to :profile
    end
  end

  def create
    role = params["role"]
    if role == "Student"
      @user = Student.new params['user']
    elsif role == "Teacher"
      @user = Teacher.new params['user']
    end

    if @user.save
      UserMailer.delay.confirmation_email(@user) # normally this would be .deliver at the end
      # but not with the DelayedJob delay in there
      @user.save
      $stderr.puts("I JUST SENT THE FRICKIN EMAIL GUYS")
      render 'users/confirmjs'
    else
      @prefix = "user_"
      @errors = @user.errors
      @fields = [:name, :password, :password_confirmation, :email]

      $stderr.puts "#"*60
      $stderr.puts "COULDN'T SAVE: #{@errors.full_messages}"

      render 'shared/form_errors'
    end
  end
end
