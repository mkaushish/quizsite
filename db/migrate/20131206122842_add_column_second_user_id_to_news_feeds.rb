class AddColumnSecondUserIdToNewsFeeds < ActiveRecord::Migration
  def change
    add_column :news_feeds, :second_user_id, :integer
  end
end
