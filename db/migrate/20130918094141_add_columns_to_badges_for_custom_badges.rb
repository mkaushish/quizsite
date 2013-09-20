class AddColumnsToBadgesForCustomBadges < ActiveRecord::Migration
  def self.up
    add_column :badges, :answer_id, :integer
    add_column :badges, :comment_id, :integer
    add_column :badges, :teacher_id, :integer
  end
  def self.down
    remove_column :badges, :answer_id
    remove_column :badges, :comment_id
    remove_column :badges, :teacher_id
  end
end
