# == Schema Information
#
# Table name: problems
#
#  id         :integer         not null, primary key
#  problem    :string
#  created_at :datetime
#  updated_at :datetime
#  user_id    :integer
#

require 'questionbase'

class Problem < ActiveRecord::Base
  include ApplicationHelper
  has_many :problemanswers
  has_one :user
  attr_writer :problem # so these can be accessible variables in the constructor
  attr_writer :ptype

  attr_accessible :problem, :ptype

  before_save :dump_problem
  before_create :generate_problem

  # Generates a random problem from ptype, if ptype is defined and problem isn't
  # raises an exception if ptype and problem are nil
  def generate_problem
    if @problem.nil? && @ptype.is_a?(Class) && @ptype < QuestionBase
      @problem = @ptype.new
      dump_problem
      $stderr.puts "PROBLEM SET TO #{@problem.inspect}"

    elsif @problem.nil?
      $stderr.puts "GENERATING PROBLEM: COULDN'T BE INITIALIZED!!!\nproblem = #{@problem.inspect}\nptype = #{@ptype.inspect} , #{@ptype.class}"
      raise 'Problem.new must be given either the problem itself of the problem class'
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

  # should be passed the params variable returned by the HTML form
  def correct?(params)
    problem.correct?(params)
  end

  def solve
    problem.prefix_solve
  end

  def get_response(params)
    @response ||= params.select { |k, v| k =~ /^qbans_/ }
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

  def custom?
    (problem.class < CustomProblem) && true # for some reason that was giving nil for a while
  end
end
