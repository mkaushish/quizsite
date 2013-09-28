class AddSecondUserIdClassroomIdToNewsFeeds < ActiveRecord::Migration
  def change
    add_column :news_feeds, :second_user_id, :integer
    add_column :news_feeds, :classroom_id, :integer
  end
end
