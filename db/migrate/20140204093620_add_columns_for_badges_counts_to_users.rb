class AddColumnsForBadgesCountsToUsers < ActiveRecord::Migration
	def change
		add_column :users, :badges_level_1_count, :integer, default:	0
		add_column :users, :badges_level_2_count, :integer, default:	0
		add_column :users, :badges_level_3_count, :integer, default:	0
		add_column :users, :badges_level_4_count, :integer, default:	0
		add_column :users, :badges_level_5_count, :integer, default:	0
		add_column :users, :badges_count, :integer, default:	0
	end
end