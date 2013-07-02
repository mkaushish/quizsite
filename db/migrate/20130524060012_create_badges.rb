class CreateBadges < ActiveRecord::Migration
  def self.up
    create_table :badges do |t|

      t.timestamps
    end
  end
end
