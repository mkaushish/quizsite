class CreateProblemanswers < ActiveRecord::Migration
  def change
    create_table :problemanswers do |t|
      t.boolean :correct
      t.integer :problem_id
      t.binary   :response

      t.timestamps
    end
  end
end
