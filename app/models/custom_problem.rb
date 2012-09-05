class CustomProblem < ActiveRecord::Base
  attr_accessor :text
  belongs_to :user
  serialize :problem

  validates :chapter, :presence => true
  validates :user_id, :presence => true
  validates :name,    :presence => true
  validates :problem, :presence => true

  def text
    self.problem.text
  end
end
