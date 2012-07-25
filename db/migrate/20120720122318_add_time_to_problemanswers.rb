class AddTimeToProblemanswers < ActiveRecord::Migration
  def change
    change_table :problemanswers do |t|
      t.float :time_taken
    end
  end
end
