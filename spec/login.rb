def login_as(user)
  @request.session[:user_id] = user ? user.id : nil
end
