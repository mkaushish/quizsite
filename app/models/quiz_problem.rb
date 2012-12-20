class QuizProblem < ActiveRecord::Base
  attr_accessible :problem_type, :count

  belongs_to :quiz
  belongs_to :problem_type

  validates :quiz, :presence => true
  validates :problem_type, :presence => true
  validates :count, :presence => true,
                    :numericality => { :only_integer => true, :greater_than => 0 }
                    # Our form should disallow assigning 0 problems anyway
end
