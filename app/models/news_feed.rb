class NewsFeed < ActiveRecord::Base

	belongs_to :user, counter_cache: :news_feeds_count

  attr_accessible :badge_id, :content, :feed_type, :problem_id, :problem_set_id, :problem_type_id, :quiz_id, :user_id, :comment_id, :topic_id, :answer_id, :second_user_id, :read_notification
end
