class CreateProblems < ActiveRecord::Migration
  def change
    create_table :problems do |t|
      t.binary :problem

      t.timestamps
    end
  end
end
