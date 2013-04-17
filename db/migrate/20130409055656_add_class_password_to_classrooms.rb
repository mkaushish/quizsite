class AddClassPasswordToClassrooms < ActiveRecord::Migration
  def change
    add_column :classrooms, :password, :string
    add_index :classrooms, :password, :unique => true
  end
end
