class RenameTypeToPclassInProblemanswers < ActiveRecord::Migration
  def change
    rename_column :problemanswers, :type, :pclass
  end
end
