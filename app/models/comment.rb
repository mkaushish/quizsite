class Comment < ActiveRecord::Base
	attr_accessible :answer_id, :classroom_id, :content, :user_id, :reply_comment_id, :topic_id

	has_many :replies, :class_name => "Comment", 
						:foreign_key => "reply_comment_id",
						:dependent => :destroy

 	belongs_to :reply_of, :class_name => "Comment", 
 						:foreign_key => "reply_comment_id"
	belongs_to :user
	belongs_to :answer
	belongs_to :topics, :counter_cache => true
	belongs_to :classroom


	validates :content, :user_id, :presence => :true
	auto_html_for :content do
        html_escape
        image
        youtube(:width => 400, :height => 250)
        link :target => "_blank", :rel => "nofollow"
        simple_format
    end
end
