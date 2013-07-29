module SessionsHelper
  # USER RELATED
  def sign_in(user)
    # TODO remove when/if we put confirmation back in
    # temporarily, to confirm all users
    unless user.confirmed
      user.confirmed = true
      user.save :validate => false
    end
    cookies.permanent.signed[:remember_token] = [user.id, user.salt]
    self.current_user = user
  end

  def current_user=(user)
    @current_user = user
  end

  def current_user
    @current_user ||= user_from_remember_token
  end

  def students_teacher
    if current_user.is_a? Student
      @students_teacher ||= current_user.teachers.first
    else
      nil
    end
  end

  def signed_in?
    !current_user.nil? && current_user.confirmed?
  end

  def sign_out
    cookies.delete(:remember_token)
    self.current_user = nil
  end

  def deny_access
    redirect_to access_denied_path, :notice => "Please sign in to access this page"
  end

  def belongs_to_user(item)
    item.user_id == current_user.id
  end

  private
  
  def user_from_remember_token
    User.authenticate_with_salt(*remember_token)
  end

  def remember_token
    cookies.signed[:remember_token] || [nil, nil]
  end
end
