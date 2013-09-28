class AddColumnCommentIdToNewsFeeds < ActiveRecord::Migration
  	def change
    	add_column :news_feeds, :comment_id, :integer
  	end
end
