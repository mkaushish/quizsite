class AddColumnStudentIdToBadges < ActiveRecord::Migration
  def self.up
  	add_column :badges, :student_id, :integer
  end
  def self.down
  	remove_column :badges, :student_id
  end
end
