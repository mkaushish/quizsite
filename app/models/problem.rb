# == Schema Information
#
# Table name: problems
#
#  id         :integer         not null, primary key
#  problem    :string
#  created_at :datetime
#  updated_at :datetime
#

class Problem < ActiveRecord::Base
  include ApplicationHelper
  has_many :problemanswers
  attr_writer :prob

  attr_accessible :problem, :prob

  before_save :dump_problem

  def dump_problem
    self.problem ||= m_pack(@prob)
  end

  def load_problem
    @prob = m_unpack(self.problem)
  end

  def unpack
    load_problem
  end

  # should be passed the params variable returned by the HTML form
  def correct?(params)
    @prob.correct?(params)
  end

  def solve
    @prob.prefix_solve
  end

  def get_response(params)
    @response ||= prob.get_useful_response(params)
  end

  def get_packed_response(params)
    m_pack(get_response(params))
  end

  def to_s
    self.prob.type
  end

  def prob
    @prob ||= load_problem
  end

  def my_initialize(type)
    unless type.is_a? Class
      raise "Problem's initialize must be passed a class"
    end

    @prob = type.new
    unless @prob.is_a? QuestionBase
      raise "Problem's initialize must be passed a class which extends QuestionBase"
    end
  end

  def text
    @prob.text
  end
end
