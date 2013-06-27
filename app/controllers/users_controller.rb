class UsersController < ApplicationController
    include TeachersHelper
  
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
            UserMailer.welcome_email(student).deliver
            sign_in student
            redirect_to studenthome_path
        end
    end
end