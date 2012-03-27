class SessionsController < ApplicationController
  def new
    @title = "Sign in"
  end

  def create
    $stderr.puts("#{"FARTS"*10}\n#{params[:session][:email]}, #{params[:session][:password]}")

    user = nil
    unless params[:email].nil?
      user = User.authenticate(params[:email],
                               params[:password])
    else
      user = User.authenticate(params[:session][:email],
                               params[:session][:password])
    end

    if user.nil?
      flash.now[:error] = "Invalid email/password combination."
      @title = "Sign in"
      redirect_to signinpage_path
    else
      sign_in user
      redirect_to user
    end
  end

  def destroy
    sign_out
    redirect_to root_path
  end
end
