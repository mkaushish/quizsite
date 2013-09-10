class Comment < ActiveRecord::Base
	attr_accessible :answer_id, :classroom_id, :content, :user_id, :reply_comment_id

	has_many :replies, :class_name => "Comment", 
						:foreign_key => "reply_comment_id",
						:dependent => :destroy

 	belongs_to :reply_of, :class_name => "Comment", 
 						:foreign_key => "reply_comment_id"
	belongs_to :user
	belongs_to :answer
	belongs_to :classroom

	validates :content, :presence => :true
end
