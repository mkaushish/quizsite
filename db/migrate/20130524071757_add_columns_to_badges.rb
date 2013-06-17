class AddColumnsToBadges < ActiveRecord::Migration
  	def self.up
  		add_column :badges, :name, :string
  		add_column :badges, :badge_key, :string
  	end
  	def self.down
  		remove_column :badges, :name
  		remove_column :badges, :badge_key
  	end
end
