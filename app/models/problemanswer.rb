# == Schema Information
#
# Table name: problemanswers
#
#  id         :integer         not null, primary key
#  correct    :boolean
#  problem_id :integer
#  created_at :datetime
#  updated_at :datetime
#  response   :string
#  user_id    :integer
#  type       :string
#

class Problemanswer < ActiveRecord::Base
  include ApplicationHelper
  belongs_to :problem
  belongs_to :user
  belongs_to :problem_generator
  delegate :problem_type, :to => :problem

  attr_accessible :problem, :problem_id, :response,  :correct, :time_taken, :notepad

  validates :problem_id, :presence => true
  validates :response,   :presence => true

  before_create :dump_response, :get_problem_generator
  after_create :update_stats
  
  def response_hash
    @response_hash ||= m_unpack(self.response)
  end

  def update_stats
    if self.user.is_a?(User)
      $stderr.puts "PROBLEMTYPE = #{problem_type.inspect}"
      self.user.update_stats(problem_type, correct) unless self.user.nil?
    end
  end

  # private TODO make sure this works with callbacks

  def get_problem_generator
    self.problem_generator = problem.problem_generator
  end

  def dump_response
    unless @response_hash.nil? || self.response != nil
      self.response = m_pack(@response_hash)
    end

    self.pclass = self.problem.problem.class.to_s
  end

end
