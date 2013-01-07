class SessionsController < ApplicationController
  def new
    @title = "Sign in"
  end

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
      $stderr.puts "REGISTERING NEW USER"
      @user = User.new
      render 'users/new_user_modal'
      return
    end

    user = nil
    pssw = ""
    unless params[:email].nil?
      user = User.find_by_email params[:email].downcase
      pssw = params[:password]
    else
      user = User.find_by_email params[:session][:email].downcase
      pssw = params[:session][:password]
    end

    if user.nil?
      render :js => "$('#userfield input').addClass('invalid');" +
                    "$('#psswfield input').addClass('invalid');" +
                    "$('#userfield input').select()"
    elsif !user.has_password? pssw
      render :js => "$('#userfield input').removeClass('invalid');" +
                    "$('#psswfield input').addClass('invalid');" +
                    "$('#psswfield input').select()"
    else
      sign_in user
      render :js => "window.location = '/'"
    end
  end

  def destroy
    sign_out
    redirect_to root_path
  end
end
