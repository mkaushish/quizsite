class AddColumnAnswerIdToBadges < ActiveRecord::Migration
  def change
    add_column :badges, :answer_id, :integer
  end
end
