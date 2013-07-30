class UsersController < ApplicationController
    include TeachersHelper
  
    before_filter :validate_user

    def password_form
        redirect_to root_path unless signed_in?
    end

    def self.change_password
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
                redirect_to studenthome_path
                return
            end
        end
        # on success we get redirected anyway
        render 'password_form'
    end

    def create_user_vdp
        @auth = request.env["omniauth.auth"]
        @user = User.find_by_provider_and_uid(@auth[:provider], @auth[:uid]) 
        if @user
            sign_in @user
            redirect_to root_path
        else  
            student = Student.create_with_omniauth(@auth)
            # UserMailer.welcome_email(student).deliver
            sign_in student
            redirect_to studenthome_path
        end
    end

    def signup
    end

    # Signup_step 1: Takes user email and user_type(like student, teacher, coach) #
    def signup_step1
        @email = params[:email] if defined? params[:email]
        @password = params[:password] if defined? params[:password]

        if defined? params[:type]
            case params[:type]
                when 'Student'
                    @student = Student.create(:email => @email, :password => @password, :password_confirmation => @password)
                when 'Teacher'
                    @teacher = Teacher.create(:email => @email, :password => @password, :password_confirmation => @password)
                when 'Coach'
                    @coach = Coach.create(:email => @email, :password => @password, :password_confirmation => @password)
                else
                    redirect_to root_path, notice: "Please choose your type!!"
            end
        end
        redirect_to root_path, notice: "Please check your inbox for account confirmation"
    end

    # Signup_step : checks the token with the confirmation code if both is same then user asked to give all details #
    def signup_step2
        if defined? params[:token]
            @confirmation_token = params[:token] if defined? params[:token]
            if @user.confirmation_token == @confirmation_token
                respond_to do |format|
                    format.html
                end
            end
        else
            redirect_to root_path, notice: "Invalid Token"
        end
    end

    def signup_step3
        if defined? (params[:token] and params[:confirmation_code])
            @confirmation_token = params[:token]
            @confirmation_code = params[:confirmation_code]
            if @user.confirmation_code == @confirmation_code and @user.confirmation_token == @confirmation_token
                respond_to do |format|
                    format.js
                end
            else
                redirect_to confirm_path(@user, :token => @confirmation_token)
            end
        end
    end

    def signup_step4
        @user.name = params[:name]
        @user.image = params[:image] if defined? params[:image]
        @user.confirmed = true
        @user.save
        if @user.is_a? (Student)
            if params[:class_pass].empty?
                @classroom = Classroom.smarter_grades
            else
                @classroom = Classroom.find_by_student_password(params[:class_pass])
            end
            @classroom.assign!(@user)
            sign_in @user
            redirect_to studenthome_path, notice: 'Welcome To SmarterGrades!!'
        elsif @user.is_a? (Teacher)
            unless params[:classroom_name].empty?
                @classroom_name = params[:classroom_name]
                @classroom = Classroom.create(:name => @classroom_name)
                @classroom_teacher = @classroom.classroom_teachers.create(:teacher_id => @user.id) unless @classroom.nil?
            end
            sign_in @user
            redirect_to teacherhome_path, notice: 'Welcome To SmarterGrades!!'
        elsif @user.is_a? (Coach)
            sign_in @user
            redirect_to coachhome_path, notice: 'Welcome To SmarterGrades!!'
        end
    end
    
    private

    def validate_user
        @user = User.find_by_id(params[:id])
    end
end