class AddNotepadToProblemanswer < ActiveRecord::Migration
  def change
    change_table :problemanswers do |t|
      t.string :notepad
    end
  end
end
