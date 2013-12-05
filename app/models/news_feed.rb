class NewsFeed < ActiveRecord::Base
  attr_accessible :badge_id, :content, :feed_type, :problem_id, :problem_set_id, :problem_type_id, :quiz_id, :user_id, :comment_id, :topic_id, :answer_id, :second_user_id
end
