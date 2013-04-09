class AddClassPasswordToClassrooms < ActiveRecord::Migration
  def change
    add_column :classrooms, :password, :string, :unique => true
  end
end
