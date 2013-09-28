class AddColumnTopicIdAnswerIdToNewsFeeds < ActiveRecord::Migration
  def change
    add_column :news_feeds, :topic_id, :integer
    add_column :news_feeds, :answer_id, :integer
  end
end