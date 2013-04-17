#Copyright (c) 2010 Michael Hartl
#
#   Permission is hereby granted, free of charge, to any person
#   obtaining a copy of this software and associated documentation
#   files (the "Software"), to deal in the Software without
#   restriction, including without limitation the rights to use,
#   copy, modify, merge, publish, distribute, sublicense, and/or sell
#   copies of the Software, and to permit persons to whom the
#   Software is furnished to do so, subject to the following
#   conditions:
#
#   The above copyright notice and this permission notice shall be
#   included in all copies or substantial portions of the Software.
#
#   THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
#   EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
#   OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
#   NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
#   HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
#   WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
#   FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
#   OTHER DEALINGS IN THE SOFTWARE.
#/*
# * ------------------------------------------------------------
# * "THE BEERWARE LICENSE" (Revision 42):
# * Michael Hartl wrote this code. As long as you retain this 
# * notice, you can do whatever you want with this stuff. If we
# * meet someday, and you think this stuff is worth it, you can
# * buy me a beer in return.
# * ------------------------------------------------------------
# */

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
      @students_seacher || current_user.teachers.first
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

  # USER QUIZ RELATED
  def get_probs
    return [] if session[:problems].nil?
    session[:problems].map { |p| dec_prob(p) }
  end

  def set_probs(*probs)
    myprobs = (probs[0].is_a? Array) ? probs[0] : probs
    session[:problems] = myprobs.map { |p| enc_prob(p) }
  end

  def set_examples(ptype)
    session[:ptype] = ptype.to_s
  end

  def in_examples?
    !session[:ptype].nil?
  end

  def example_type
    session[:ptype].constantize
  end

  def set_quiz(quiz)
    session[:ptype] = nil
    session[:quizid] = quiz.id
    set_probs quiz.ptypes
  end

  def stop_quiz
    session[:quizid] = nil
    session[:problems] = []
  end

  def quiz_name
    Quiz.find(session[:quizid]).name
  end

  def in_quiz?
    return !session[:quizid].nil?
  end

  # NOTE below 3 methods can ONLY be called when (signed_in? && in_quiz?)
  # otherwise an uncaught exception WILL BE THROWN
  def quiz_user
    @quiz_user ||= current_user.quiz_users.where(:quiz_id => session[:quizid].to_i)[0]
  end

  def next_problem
    return quiz_user.next_problem
  end

  # increments the user's progress through the quiz based on whether they got the last problem right
  def increment_problem(last_correct)
    if in_quiz?
      quiz_user.increment_problem(last_correct)
    end
  end

  private
  
  def user_from_remember_token
    User.authenticate_with_salt(*remember_token)
  end

  def remember_token
    cookies.signed[:remember_token] || [nil, nil]
  end
end
