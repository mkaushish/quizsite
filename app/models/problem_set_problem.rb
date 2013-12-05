class ProblemSetProblem < ActiveRecord::Base
  belongs_to :problem_set
  belongs_to :problem_type

  validates :problem_set, :presence => true
  validates :problem_type, :presence => true
end
