class AddColumnTeacherIdToBadges < ActiveRecord::Migration
  def change
    add_column :badges, :teacher_id, :integer
  end
end
