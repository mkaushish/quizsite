class RemovePaperclipDefaultColumnsFromUser < ActiveRecord::Migration
  def self.up
  	remove_column :users, :image_file_name
  	remove_column :users, :image_content_type
  	remove_column :users, :image_file_size
  	remove_column :users, :image_updated_at
  	 
  	add_column :users, :image, :string
  end

  def self.down
  	remove_column :users, :image
  end
end
