class AddResponseToProblemanswer < ActiveRecord::Migration
  def change
    add_column :problemanswers, :response, :text
  end
end
