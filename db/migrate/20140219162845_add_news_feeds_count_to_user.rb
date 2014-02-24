class AddNewsFeedsCountToUser < ActiveRecord::Migration
  def change
  	add_column :users, :news_feeds_count, :integer, :default => 0
  end
end
