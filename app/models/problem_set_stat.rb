class ProblemSetStat < ActiveRecord::Base
  include CurrentProblem
  include FollowsProblemStat

  belongs_to :problem_type

  belongs_to :problem_set_instance
  delegate   :user, :to => :problem_set_instance

  validates :problem_set_instance, :presence => true

  before_create :assign_problem_stat

  def update!(answer)
    self.problem_stat = stat.update!(answer)
    change_problem
    save ? self : nil
  end

  # TODO make last_correct? look up the last problem if @last_correct.nil?
  def last_correct?
    return @last_correct || false
  end

  def calculate_points(answer)
    stat.calculate_points(answer)
  end

  def problem_stat
    self.problem_stat ||= ( ProblemStat.where(user: user.id, problem_type: problem_type_id)
                           || ProblemStat.new(user: user.id, problem_type: problem_type_id))
  end
end
