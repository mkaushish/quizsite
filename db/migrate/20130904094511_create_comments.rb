class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.string :content
      t.integer :user_id
      t.integer :answer_id
      t.integer :classroom_id

      t.timestamps
    end
  end
end
