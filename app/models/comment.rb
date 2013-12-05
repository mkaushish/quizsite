class Comment < ActiveRecord::Base
	
    attr_accessible :answer_id, :classroom_id, :content, :user_id, :reply_comment_id, :topic_id

	has_many :replies, :class_name => "Comment", 
						:foreign_key => "reply_comment_id",
						:dependent => :destroy
	has_one :merit, :class_name => "Badge", 
                        :foreign_key => "comment_id",
                        :conditions => "answer_id IS NULL",
                        :dependent => :destroy

 	belongs_to :reply_of, :class_name => "Comment", 
 						:foreign_key => "reply_comment_id"
	belongs_to :user
	belongs_to :answer

	belongs_to :topic, :counter_cache => true
	belongs_to :classroom

	validates :content, :user_id, :presence => :true
	
	after_create :send_notification_to_teacher_if_student_replied, :send_notification_to_teacher_if_owned_topic

	auto_html_for :content do
        html_escape
        image
        youtube(:width => 400, :height => 250)
        link :target => "_blank", :rel => "nofollow"
        simple_format
    end

    private

    def send_notification_to_teacher_if_student_replied
    	parent_comment = self.reply_of
    	unless parent_comment.blank?
    		if parent_comment.user.is_a? Teacher and self.user.is_a? Student
    			parent_comment.user.news_feeds.create(:content => "You have got a reply on your comment from #{self.user.name}", :feed_type => "Reply on Comment", :comment_id => "#{parent_comment.id}")
    		end
    	end
    end
    def send_notification_to_teacher_if_owned_topic
    	topic = self.topic
    	unless topic.blank?
    		user = topic.user
    		if topic.user.is_a? Teacher and self.user.is_a? Student
    			user.news_feeds.create(:content => "#{self.user.name} has commented on your topic #{topic.title}", :feed_type => "Comment on Topic", :topic_id => "#{topic.id}")
    		end
    	end
    end
end
