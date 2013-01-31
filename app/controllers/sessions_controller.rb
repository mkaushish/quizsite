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
    if params[:commit] == "Register"
      @user = User.new
      render 'register_as'
      return
    end

    @email = params[:session][:email].downcase
    @user = User.find_by_email @email
    @pssw = params[:session][:password]

    if @user && @user.has_password?(@pssw)
      sign_in @user
      render :js => "window.location = '/'"
    else
      render 'errors'
    end
  end

  def destroy
    sign_out
    redirect_to root_path
  end
end
