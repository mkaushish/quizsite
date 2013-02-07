module FollowsProblemStat
  extend ActiveSupport::Concern

  included do
    belongs_to :problem_stat
    # delegate :count, :correct, to: :problem_stat
  end

  def assign_problem_stat!
    self.problem_stat = stat
  end

  def smart_score
    return problem_stat.smart_score unless problem_stat.nil?
    "?"
  end

  def stat
    self.problem_stat || 
      user.problem_stats.where(:problem_type_id => problem_type_id).first ||
      user.problem_stats.new(:problem_type => problem_type)
  end

  def method_missing(sym, *args)
    if [:count, :correct].include?(sym)
      stat.send sym
    end
  end
end
