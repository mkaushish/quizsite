class QuizInstance < ActiveRecord::Base
  belongs_to :quiz
  belongs_to :user

  has_many :quiz_stats, :dependent => :destroy
  has_many :quiz_problems, :through => :quiz

  has_many :answers, :as => :session

  validates :user, :presence => true
  validates :quiz, :presence => true

  delegate :name, :idname, :to => :quiz

  def start
    if !self.complete.nil?
      return false
    end

    self.complete = false
    self.started_at = Time.now
    self.quiz_stats.create quiz.stat_attrs

    return true
  end

  def end
    self.ended_at = Time.now
    self.complete = true
  end
end
