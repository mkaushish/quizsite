class AddColumnLevelToBadges < ActiveRecord::Migration
  def change
    add_column :badges, :level, :integer
  end
end