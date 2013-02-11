class ProblemSetInstance < ActiveRecord::Base
  belongs_to :problem_set
  belongs_to :user

  has_many :problem_set_stats, :dependent => :destroy
  has_many :problem_types, :through => :problem_set

  has_many :problems, :as => :session

  validates :user, :presence => true
  validates :problem_set, :presence => true

  delegate :name, :idname, :to => :problem_set

  def stats
    # return @tmpstats unless @tmpstats.nil?

    @tmpstats = []
    # existing stats are for problems a student has already done
    existing_stats = self.problem_set_stats.includes(:problem_stat).includes(:problem_type)
                         .sort { |i, j| i.problem_type_id <=> j.problem_type_id }

    # we merge these with new stats (without saving them), for problem types that are in the problem set
    # but that the student has yet to attempt
    all_ptypes = problem_set.problem_types.sort { |i, j| i.id <=> j.id }

    problem_stats = user.problem_stats.where(:problem_type_id => all_ptypes.map(&:id))

    j, k = 0, 0
    all_ptypes.length.times do |i|
      next_stat = nil
      if j < existing_stats.length && existing_stats[j].problem_type == all_ptypes[i]
        next_stat = existing_stats[j]
        j += 1
      else
        next_stat = new_stat(all_ptypes[i])
      end

      if k < problem_stats.length && problem_stats[k].problem_type == all_ptypes[i]
        next_stat.problem_stat ||= problem_stats[k]
        k += 1
      end

      @tmpstats << next_stat
    end

    self.problem_set_stats = @tmpstats
  end

  def stat(problem_type)
    stat = self.problem_set_stats.where(:problem_type_id => problem_type.id).first
    stat ||= new_stat problem_type, true
  end

  def modify_green?(green_time)
    stats.each do |stat| 
      return "yellow" unless my_stat.green?
    end
    return 'green'
  end

  private

  def new_stat(problem_type, look_up_problem_stat = false)
      my_stat = self.problem_set_stats.new(:problem_type => problem_type)
      my_stat.assign_problem_stat! if look_up_problem_stat
      my_stat
  end

end
