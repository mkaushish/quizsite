class QuizInstance < ActiveRecord::Base
  belongs_to :quiz
  belongs_to :user

  has_many :quiz_stats, :dependent => :destroy
  has_many :quiz_problems, :through => :quiz

  has_many :answers, :as => :session

  validates :user, :presence => true
  validates :quiz, :presence => true

  delegate :name, :idname, :to => :quiz

  def stats
    existing_stats = self.quiz_stats.includes(:problem_stat).includes(:problem_type)
                         .sort { |i, j| i.problem_type_id <=> j.problem_type_id }
    
  end
end
