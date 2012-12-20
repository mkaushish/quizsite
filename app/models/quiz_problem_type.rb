# join table for the problem types in quizzes
#   problem_set_id    => either a quiz or a quiz_user
#
#   problem_set_type  => either "Quiz" or "QuizUser"
#
#   problem_type      => the problem type, obv
#
#   count             => for a quiz: the number of problems you need to do in order to be done
#                     => for a quiz_user: the number of problems that the user has done upon creation of the quiz_user
#
#   user_stat         => for a quiz_user
class ProblemSetElt < ActiveRecord::Base
  attr_accessible :problem_type, :count, :user_stat

  belongs_to :problem_set, :polymorphic => true
  belongs_to :problem_type

  validates :problem_set, :presence => true
  validates :problem_type, :presence => true
end
