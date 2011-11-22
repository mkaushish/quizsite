class AddResponseToProblemanswer < ActiveRecord::Migration
  def change
    add_column :problemanswers, :response, :string
  end
end
