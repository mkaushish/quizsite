class AddColumnBodyToProblems < ActiveRecord::Migration
  def change
    add_column :problems, :body, :string
  end
end
