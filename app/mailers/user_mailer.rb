class UserMailer < ActionMailer::Base
  default :from => "noreply@smartergrades.com"

  def confirmation_email(user)
    @user = user
    mail(:to => user.email, :subject => "Welcome to SmarterGrades")
  end
end