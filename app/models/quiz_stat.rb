class QuizStat < ActiveRecord::Base
  include CurrentProblem
  include FollowsProblemStat

  belongs_to :problem_type
  belongs_to :quiz_instance
  delegate   :user, :to => :quiz_instance

  validates :quiz_instance, :presence => true

  # should we include the problem stat here as well? Probably...  TODO

  def update!(answer)
    remaining -= 1

    if remaining <= 0
      delete
      return nil
    end

    change_problem
    self
  end

  def calculate_points(answer)
    5
  end
end
