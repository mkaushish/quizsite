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

  attr_accessible :problem, :problem_id, :response,  :correct, :time_taken, :notepad

  validates :problem_id, :presence => true
  #validates :user_id,    :presence => true
  validates :response,   :presence => true

  before_save :bef_save
  
  def bef_save
    dump_response
    self.pclass=self.problem.prob.class.to_s
  end
  
  def dump_response
    unless @response_hash.nil? || self.response != nil
      self.response = m_pack(@response_hash)
    end
  end

  def response_hash
    @response_hash ||= m_unpack(self.response)
  end
end
