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

  has_many :answers, :as => :session

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

    return true
  end

  def finish
    self.ended_at = Time.now
    self.complete = true
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
end
