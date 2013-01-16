class QuizInstance < ActiveRecord::Base
  belongs_to :quiz
  belongs_to :user

  has_many :quiz_problem_stats, :dependent => :destroy
  has_many :quiz_problems, :through => :quiz

  validates :user, :presence => true
  validates :quiz, :presence => true

  delegate :name, :idname, :to => :problem_set

  def stats
    existing_stats = self.problem_set_stats.includes(:problem_stat).includes(:problem_type)
                         .sort { |i, j| i.problem_type_id <=> j.problem_type_id }
    
  end
end
