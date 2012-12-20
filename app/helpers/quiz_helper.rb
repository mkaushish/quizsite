module QuizHelper
  def get_quiz_quiz_user(id)
    quiz = Quiz.find(id)
    return [quiz, nil] if current_user.nil?

    quiz_users = quiz.quiz_users.where(:user => current_user)
    return [quiz, nil] if quiz_users.empty?
    [quiz, quiz_users.first] # there can only be one anyway
  end
end
