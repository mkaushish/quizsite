class QuizProblem < ActiveRecord::Base
  belongs_to :quiz, inverse_of: :quiz_problems
  belongs_to :problem_type

  validates :quiz, :presence => true
  validates :problem_type, :presence => true
  validates :count, :presence => true,
                    :numericality => { :only_integer => true, :greater_than => 0 }
                    # Our form should disallow assigning 0 problems anyway

  scope :partial, where(:partial => true)

  QUIZ_PROB_CATEGORY = { 1 => "Random", 2 => "Custom Problem"}

  def quiz_prob_category
    QUIZ_PROB_CATEGORY[status]
  end
  
  def self.quiz_prob_category_array
    QUIZ_PROB_CATEGORY.to_a.sort
  end
end
