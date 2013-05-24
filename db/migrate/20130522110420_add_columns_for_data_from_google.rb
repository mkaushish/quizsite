class AddColumnsForDataFromGoogle < ActiveRecord::Migration
  def self.up
  	add_column :users, :first_name, :string
  	add_column :users, :last_name, :string
  	add_column :users, :gender, :string
  	add_column :users, :uid, :string
  	add_column :users, :profile_link, :string
  	add_column :users, :picture_link, :string
  	add_column :users, :provider, :string
  end
  def self.down
  	remove_column :users, :first_name
  	remove_column :users, :last_name
  	remove_column :users, :gender
  	remove_column :users, :uid
  	remove_column :users, :profile_link
  	remove_column :users, :picture_link
  	remove_column :users, :provider
  end
end
