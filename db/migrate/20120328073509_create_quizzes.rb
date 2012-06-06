class CreateQuizzes < ActiveRecord::Migration
  def change
    create_table :quizzes do |t|
      t.binary :problemtypes
      t.integer :user_id

      t.timestamps
    end
    add_column :problemanswers, :pclass, :string
    add_index  :problemanswers, [:user_id, :pclass, :created_at]

    add_column :users, :pscores, :binary
  end
end
