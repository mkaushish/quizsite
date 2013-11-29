class AddColumnCommentIdToBadges < ActiveRecord::Migration
  def change
    add_column :badges, :comment_id, :integer
  end
end
