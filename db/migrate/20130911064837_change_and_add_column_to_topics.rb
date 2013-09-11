class ChangeAndAddColumnToTopics < ActiveRecord::Migration
  def up
  	change_column :topics, :content, :string
  	rename_column :topics, :content, :title
  	add_column :topics, :description, :text
  end

  def down
	rename_column :topics, :title, :content
  	change_column :topics, :content, :text
  	remove_column :topics, :description
  end
end
