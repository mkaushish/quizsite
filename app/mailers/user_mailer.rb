class UserMailer < ActionMailer::Base
  default :from => "noreply@smartergrades.com"

  def account_confirmation_email(user)
    @user = user
    mail(:to => @user.email, :subject => "Welcome to SmarterGrades. Please Confirm Your Account!")
  end

  def welcome_email(user)
  	@user = user
  	email_with_name = "#{@user.name} <#{@user.email}>"
  	mail(:to => @user.email, :subject => "Welcome to SmarterGrades")
  end
end
