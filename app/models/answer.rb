# == Schema Information
#
# Table name: answers
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

class Answer < ActiveRecord::Base
  include ApplicationHelper
  belongs_to :problem
  belongs_to :user
  belongs_to :problem_generator
  delegate :problem_type, :to => :problem
  belongs_to :session, :polymorphic => true

  attr_writer :params
  attr_accessible :params, :session # this is a practice session not a cookie

  validates :problem_id, :presence => true
  validates :response,   :presence => true

  before_validation :parse_params
  before_save       :dump_response

  def parse_params
    if !@params.nil? && self.problem.nil?
      self.problem    = Problem.find @params["problem_id"]
      self.time_taken = @params["time_taken"]
      self.correct    = problem.correct? @params
      self.response   = problem.get_packed_response @params
      self.notepad    = (@params["npstr"].empty?) ? nil : @params["npstr"]
      self.problem_generator = problem.problem_generator
    end
    self
  end
  
  def response_hash
    @response_hash ||= m_unpack(self.response)
  end

  def dump_response
    unless @response_hash.nil? || self.response != nil
      self.response = m_pack(@response_hash)
    end
  end
end
