class SessionsController < ApplicationController
    def switch_to
        # TODO
        session[:current_student] = current_user
        # session[:return_to_path] = 
        user = User.find_by_email session[:email]
        sign_in user if user.has_password? session[:password]
        redirect_to teacherhome_path
    end

    def create
        @email = params[:login_email].downcase
        @pssw = params[:login_password]
        @user = User.find_by_email @email
        if @user && @user.has_password?(@pssw)
            sign_in @user
            render :js => "window.location.href = '/'"
        else
            #flash[:email] = @email
            #flash[:password] = @password
            if @user
                flash[:error] = "Wrong password for #{@user.email}"
                render :js => form_err_js(:login_password, "Invalid password for #{@user.email}")
            else
                flash[:error] = "The ID #{@email.downcase} is not in use." +
                                "  Would you like to register?"
                render :js => form_err_js(:login_email, "Hey put something in the fields first !") if params[:login_email].nil?
                render :js => form_err_js(:login_email, "The ID #{@email.downcase} is not in use." +
                                "  Would you like to register?")
            end
        end
    end

    def destroy
        sign_out
        redirect_to root_path
    end
end
