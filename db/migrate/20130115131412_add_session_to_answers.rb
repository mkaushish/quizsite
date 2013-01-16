class AddSessionToAnswers < ActiveRecord::Migration
  def up
    rename_table :problemanswers, :answers
    change_table :answers do |t|
      t.references :session, :polymorphic => true
    end
  end

  def self.down
    change_table :answers do |t|
      t.remove_references :session, :polymorphic => true
    end
    rename_table :answers, :problemanswers
  end
end
