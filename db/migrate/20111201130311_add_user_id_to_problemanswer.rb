class AddUserIdToProblemanswer < ActiveRecord::Migration
  def change
    add_column :problemanswers, :user_id, :integer
    add_index :problemanswers, :user_id
    add_index :problemanswers, [:user_id, :created_at]
  end
end
