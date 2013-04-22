class AddAttachmentImageToUsers < ActiveRecord::Migration
  def self.up
    change_table :users do |t|
      t.attachment :image
    end
    remove_column :users, :problem_stats
  end

  def self.down
    drop_attached_file :users, :image
  end
end
