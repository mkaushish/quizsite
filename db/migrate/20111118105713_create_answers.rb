class CreateAnswers < ActiveRecord::Migration
  def change
    create_table :answers do |t|
      t.boolean 	 :correct
      t.integer 	 :problem_id
      t.binary   	 :response
      t.integer		 :problem_generator_id
      t.float		   :time_taken
      t.integer 	 :user_id
      t.string     :notepad
      t.references :session, :polymorphic => true
      t.integer    :problem_type_id
      t.integer    :points
      
      t.timestamps
    end
    add_index :answers, [:user_id, :created_at]
  end
end