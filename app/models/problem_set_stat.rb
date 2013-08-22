class ProblemSetStat < ActiveRecord::Base
  include CurrentProblem
  include FollowsProblemStat
  include HasProgressBar

  belongs_to :problem_type
  belongs_to :problem_set_instance

  validates :problem_set_instance, :presence => true

  has_one :user, :through => :problem_set_instance

  before_create :assign_problem_stat #, :stop_green_now

  def next_stat
    stats = problem_set_instance.stats.clone
    begin
      stat = stats.shift
    end while stat.problem_type_id <= problem_type_id
    stat
  end

  def update_w_ans!(answer)
    answer.points = points_for(answer.correct)
    answer.save
    self.problem_stat = stat.update_w_ans!(answer)
    set_multiplier(answer.correct)
    change_problem
    save
    self
  end

  def points_for(correct)
    if green? || modifier == 0
      stat.points_for(correct)
    else
      (multiplier(correct) * stat.points_for(correct)).round
    end
  end
########################################################################
  # def points_for(correct)
  #   if blue? || modifier == 0
  #     stat.points_for(correct)
  #   else
  #     (multiplier(correct) * stat.points_for(correct)).round
  #   end
  # end
########################################################################

  def last_correct?
    modifier == 1
  end

  private
    def set_multiplier(correct)
      self.modifier = correct ? 1 : 0
    end

    def multiplier(correct)
      case modifier
      when 1
        correct ? 2.0 : 1.0
      when 2
        1.5
      else
        1.0
      end
    end
end