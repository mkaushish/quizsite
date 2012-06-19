class UserMailer < ActionMailer::Base
  default :from => "support@smartergrades.com"

  def confirmation_email(user)
    @user = user
    mail(:to => user.email, :subject => "Welcome to SmarterGrades")
  end
end
