class AddUserToProblems < ActiveRecord::Migration
  def change
    add_column :problems, :user_id, :integer
    rename_column :problems, :problem, :serialized_problem
  end
end
