class AddColumnReplyCommentIdToComments < ActiveRecord::Migration
  def change
    add_column :comments, :reply_comment_id, :integer
  end
end