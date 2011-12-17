# == Schema Information
#
# Table name: problemanswers
#
#  id         :integer         not null, primary key
#  correct    :boolean
#  problem_id :integer
#  created_at :datetime
#  updated_at :datetime
#  response   :string(255)
#  user_id    :integer
#

class Problemanswer < ActiveRecord::Base
  belongs_to :problem
  belongs_to :user

  attr_accessible :problem, :problem_id, :response,  :correct

  before_save :dump_response

  validates :problem_id, :presence => true
  validates :response, :presence => true
  
  def dump_response
    unless @response_hash.nil? || self.response != nil
      self.response = ActiveRecord::Base.connection.escape_bytea(Marshal.dump(@response_hash))
    end
  end

  def response_hash
    @response_hash ||= Marshal.load(ActiveRecord::Base.connection.unescape_bytea(self.response))
  end
end
