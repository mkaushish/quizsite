class QuizStat < ActiveRecord::Base
  include CurrentProblem
  include FollowsProblemStat

  belongs_to :problem_type
  belongs_to :quiz_instance
  delegate   :user, :to => :quiz_instance

  validates :quiz_instance, :presence => true

  def update!(answer)
    self.remaining = remaining - 1

    if remaining <= 0
      # destroy
      return nil
    end

    change_problem
    self
  end
end
