class AddReadNotificationToNewsFeeds < ActiveRecord::Migration
  def change
    add_column :news_feeds, :read_notification, :boolean, :default => false
  end
end
