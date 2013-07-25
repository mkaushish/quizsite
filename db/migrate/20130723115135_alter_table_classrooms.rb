class AlterTableClassrooms < ActiveRecord::Migration
  def self.up
  	add_column :classrooms, :student_password, :string
  	add_column :classrooms, :teacher_password, :string
  	remove_column :classrooms, :password
  end

  def self.down
  	remove_column :classrooms, :student_password
  	remove_column :classrooms, :teacher_password
  	add_column :classrooms, :password, :string
  end
end
