class ProblemSetStat < ActiveRecord::Base
  belongs_to :problem_stat
  belongs_to :problem_type
  belongs_to :current_problem, :class_name => "Problem"

  belongs_to :problem_set_instance
  delegate   :user, :to => :problem_set_instance

  validates :problem_set_instance, :presence => true

  before_create :assign_problem_stat

  before_save :calculate_points

  def assign_problem_stat
    self.problem_stat = ProblemStat.where(:user_id => user.id, :problem_type_id => problem_type.id).first
  end

  def smart_score
    return problem_stat.smart_score unless problem_stat.nil?
    "?"
  end

  def spawn_problem
    return self.current_problem if self.current_problem

    self.current_problem = problem_type.spawn
    save!
    self.current_problem
  end

  def update!(params)
    @last_correct = current_problem.correct?(params)

    @problemanswer = user.problemanswers.create(:problem => current_problem, 
                         :time_taken=> params["time_taken"],
                         :correct => @last_correct,
                         :response => current_problem.get_packed_response(params),
                         :notepad => (params["npstr"].empty?) ? nil : params["npstr"]) # in case it's the empty string )
    stat.update!(@last_correct)

    self.current_problem = nil
    self.problem_stat = stat

    save ? self : nil
  end

  # TODO make last_correct? look up the last problem if @last_correct.nil?
  def last_correct?
    return @last_correct || false
  end

  def calculate_points
    #TODO actually do this
    # new_record? return true if the record for the object doesn't exist yet
    self.points = 10
  end

  private

  def stat
    self.problem_stat || 
      user.problem_stats.where(:problem_type_id => problem_type_id).first ||
      user.problem_stats.new(:problem_type => problem_type)
  end
end
