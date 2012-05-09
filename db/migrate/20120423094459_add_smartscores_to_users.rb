class AddSmartscoresToUsers < ActiveRecord::Migration
  def change
    add_column :users, :smartscores, :bytea
  end
end
