class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def show
    @user = params[:id].nil? ? current_user : User.find(params[:id])

    if @user.is_a? Teacher
      redirect_to :stats
    else
      stop_quiz
      render 'students/show'
    end
  end
  
  # POST confirm
  def confirm
    @user = User.find params['id']

    if @user.confirmed?
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
      @user = current_user
      stop_quiz
      render 'students/show'
      #show && return

    elsif current_user.is_a?(Teacher)
      redirect_to :action => :stats
    end
  end

  def stats
    @title = "Stats"
    @nav_selected = "stats"

    if current_user.is_a?(Teacher)
      # Right now since thomas and madhav are the only admin accounts, test for them
      if current_user.email == "t.homasramfjord@gmail.com" ||
         current_user.email == "m.adhavkaushish@gmail.com"
        @classrooms = Classroom.all
      else
        @classrooms = current_user.classrooms
      end

      @classroom = Classroom.find params[:classroom_id] || current_user.classrooms.first
      @students  = @classroom.students.sort { |a,b| a.name <=> b.name }
      @homeworks = @classroom.homeworks

      # get best/worst kids and problem types respectively for each homework
      # @homeworks.each do |hw|
      #   homework_scores = Hash[ @students.map { |s| [s, s.quiz_score(hw)] } ]
      #   smartest_kids = @students.sort { |a, b| homework_scores[a] <=> homework_scores[b] }
      # end

      # TODO this is just for the display... come up with a real value both here and in student/show
      @shownquiz = @homeworks.where(:name => 'Chapter3')[0]
      render 'teachers/stats'
    else
      redirect_to :profile
    end
  end

  def create
    role = params["role"]
    if role == "Student"
      @user = Student.new params['user']
      @classroom = Classroom.find(params['class'])
      @classroom.assign!(@user)
    elsif role == "Teacher"
      @user = Teacher.new params['user']
    end

    if @user.save
      @user.confirmed = true
      #UserMailer.delay.confirmation_email(@user) # normally this would be .deliver at the end
      # but not with the DelayedJob delay in there
      @user.save
      sign_in @user
      $stderr.puts("I JUST SENT THE FRICKIN EMAIL GUYS")
      # TODO render confirm instead after we start doing confirmations again
      render :js => "window.location.href = '/'"
      # render 'users/confirmjs'
    else
      @prefix = "user_"
      @errors = @user.errors
      @fields = [:name, :password, :password_confirmation, :email]

      $stderr.puts "#"*60
      $stderr.puts "COULDN'T SAVE: #{@errors.full_messages}"

      render 'shared/form_errors'
    end
  end

  def password_form
    redirect_to root_path unless signed_in?
  end

  def change_password
    if !(current_user.has_password? params[:old_pass])
      flash[:error] = "Wrong old password!"
    elsif params[:password] != params[:password_confirmation]
      flash[:error] = "Hey, your password doesn't match it's confirmation!"
    else
      current_user.password = params[:password]
      current_user.password_confirmation = params[:password_confirmation]

      unless current_user.save
        flash[:error] = "Sorry, we couldn't change your password: #{current_user.errors.full_messages}"
      else
        sign_in current_user
        redirect_to profile_path
        return
      end
    end

    # on success we get redirected anyway
    render 'password_form'
  end
end
