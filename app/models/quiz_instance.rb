class QuizInstance < ActiveRecord::Base
  belongs_to :quiz
  belongs_to :user
  belongs_to :problem_set_instance
  has_one :problem_set, :through => :problem_set_instance

  has_many :quiz_stats, :dependent => :destroy
  has_many :quiz_problems, :through => :quiz

  has_many :stats_remaining, :class_name => "QuizStat", 
                             :conditions => "remaining > 0", 
                             :dependent => :destroy


  has_many :answers,  :as => :session,
                      :dependent => :destroy

  validates :user, :presence => true
  validates :quiz, :presence => true

  delegate :name, :idname, :to => :problem_set

  def start
    if !self.complete.nil?
      return false
    end

    self.complete = false
    self.started_at = Time.now
    self.quiz_stats.create quiz.stat_attrs

    # the ! makes it return false if it doesn't save
    save || !self.quiz_stats.destroy_all
  end

  def started?
    !self.complete.nil?
  end

  def finish
    self.ended_at = Time.now
    self.complete = true
    self.save
  end

  def finished?
    self.complete == true
  end
  
  def over?
    stats_remaining.empty?
  end

  def next_stat
    @next_stat ||= stats_remaining.first
  end

  def next_problem
    next_stat.spawn_problem
  end

  def stats
    self.quiz_stats 
  end

  def problems_left
    problems_left = Array.new
    problem_ids = self.quiz_problems.pluck(:problem) - self.answers.pluck(:problem_id)
    problem_ids.each do |problem_id|
      problems_left.push Problem.find_by_id(problem_id).to_s
    end
    return problems_left
  end
end