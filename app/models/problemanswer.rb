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
#

class Problemanswer < ActiveRecord::Base
  include ApplicationHelper
  belongs_to :problem
  belongs_to :user

  attr_accessible :problem, :problem_id, :response,  :correct

  before_save :dump_response

  validates :problem_id, :presence => true
  validates :response, :presence => true
  
  def dump_response
    unless @response_hash.nil? || self.response != nil
      self.response = m_pack(@response_hash)
    end
  end

  def response_hash
    @response_hash ||= m_unpack(self.response)
  end
end
