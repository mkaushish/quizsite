class Comment < ActiveRecord::Base
  attr_accessible :answer_id, :classroom_id, :content, :user_id

  belongs_to :user
  belongs_to :answer
  belongs_to :classroom
end
