class ProblemSetInstance < ActiveRecord::Base
  
  belongs_to :problem_set
  belongs_to :user

  has_many :problem_set_stats, :dependent => :destroy
  has_many :problem_stats, :through => :problem_set_stats
  has_many :problem_set_problems, :through => :problem_set
  has_many :problem_types, :through => :problem_set_problems

  has_many :assigned_quizzes, :class_name => 'QuizInstance',
                              :conditions => 'complete ISNULL'


  has_many :answers, :as => :session

  validates :user, :presence => true
  validates :problem_set, :presence => true

  delegate :name, :idname, :to => :problem_set

  def quiz_assigned?
    !assigned_quizzes.empty?
  end

  # this method prevents the need to create a new problem_set_stat for 
  # every problem_set a student has access to.  If we're adding in the default
  # problem sets, the vast majority of problem_set_stats will be for problems
  # students will never do.  
  #
  # This method returns an arry of problem_set_stats which may or may not be in 
  # the database already = they are either found or created with ActiveRecord#new
  def stats
    # return @tmpstats unless @tmpstats.nil?

    @tmpstats = []
    # existing stats are for problems a student has already done
    existing_stats = problem_set_stats.includes(:problem_stat).includes(:problem_type)
                                      .order("problem_type_id ASC")

    # we merge these with new stats (without saving them), for problem types that are in the problem set
    # but that the student has yet to attempt
    all_ptypes = problem_types.order("id ASC")

    problem_stats = user.problem_stats
                        .where(:problem_type_id => all_ptypes.map(&:id))
                        .order("problem_type_id ASC")
    j, k = 0, 0
    all_ptypes.length.times do |i|
      next_stat = nil
      # if the stat exists, take it. Else make a new one
      if j < existing_stats.length && existing_stats[j].problem_type_id == all_ptypes[i].id
        puts "found existing problem_stat for #{all_ptypes[i]}, #{all_ptypes[i].id}"
        next_stat = existing_stats[j]
        j += 1
      else
        puts "making a new problem_stat for #{all_ptypes[i]}, #{all_ptypes[i].id}, " + 
             "current stat for id #{existing_stats[j]}, j = #{j}"
        next_stat = new_stat(all_ptypes[i])
      end

      # if the problem_stat exists, take it too, else assign a new one
      if k < problem_stats.length && problem_stats[k].problem_type_id == all_ptypes[i].id
        puts "found problem_stat for problem_type #{all_ptypes[i].name}, " +
             "#{problem_stats[k].id}"
        next_stat.problem_stat ||= problem_stats[k]
        k += 1
      else
        # NOTE this "puts" causes an exception currently
        # puts "couldn't find problem stat for #{all_ptypes[i].name}, " +
        #      "next = #{problem_stats[k].id}, #{problem_stats[k].problem_type_id}, k = #{k}"
        next_stat.problem_stat = user.problem_stats.new(:problem_type_id => next_stat.problem_type_id)
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
      return "yellow" unless stat.green?
    end
    return 'green'
  end

  def num_problems
    problem_set_problems.length
  end

  private

  def new_stat(problem_type, look_up_problem_stat = false)
    debugger
      my_stat = self.problem_set_stats.new(:problem_type => problem_type)
      my_stat.assign_problem_stat! if look_up_problem_stat
      my_stat
  end
end
