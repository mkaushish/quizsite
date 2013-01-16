module FollowsProblemStat
  extend ActiveSupport::Concern
  $stderr.puts "loading module"

  included do
    belongs_to :problem_stat
    $stderr.puts "I got included"
  end

  def assign_problem_stat
    self.problem_stat = ProblemStat.where(:user_id => user.id, :problem_type_id => problem_type.id).first
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
end
