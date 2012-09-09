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
  attr_writer :problem
  attr_writer :ptype

  attr_accessible :problem, :ptype

  before_save :dump_problem
  before_create :generate_problem

  def generate_problem
    if @problem.nil? && @ptype.is_a?(Class) && @ptype < QuestionBase
      @problem = @ptype.new
      dump_problem
      $stderr.puts "PROBLEM SET TO #{@problem.inspect}"
    else
      $stderr.puts "PROBLEM COULDN'T BE INITIALIZED!!!\nproblem = #{@problem.inspect}\nptype = #{@ptype.inspect} , #{@ptype.class}"
    end
  end

  def dump_problem
    self.serialized_problem = m_pack problem
  end

  def problem
    return nil if self.serialized_problem.nil? && @problem.nil?
    @problem ||= m_unpack self.serialized_problem
  end

  def ptype
    @ptype ||= problem.class
  end

  # DEPRACATE THESE 2!!
  def load_problem
    @problem = m_unpack(self.serialized_problem)
  end

  def unpack
    load_problem
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

  # END DEPRACATED

  # should be passed the params variable returned by the HTML form
  def correct?(params)
    problem.correct?(params)
  end

  def solve
    problem.prefix_solve
  end

  def get_response(params)
    @response ||= problem.get_useful_response(params)
  end

  def get_packed_response(params)
    m_pack(get_response(params))
  end

  def to_s
    problem.type
  end

  def text
    problem.text
  end
end
