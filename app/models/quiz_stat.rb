class QuizStat < ActiveRecord::Base
  include CurrentProblem
  include FollowsProblemStat

  belongs_to :problem_type
  belongs_to :quiz_instance
  delegate   :user, :to => :quiz_instance

  validates :quiz_instance, :presence => true

  def points_for(correct = nil) ; 100 end

  def update_w_ans!(answer)
    answer.points = points_for(answer.correct)
    answer.save
    self.problem_stat = stat.update_w_ans!(answer)

    self.remaining = remaining - 1
    change_problem
    save
  end
end
