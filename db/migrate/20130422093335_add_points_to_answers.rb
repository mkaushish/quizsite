class AddPointsToAnswers < ActiveRecord::Migration
  def change
    add_column :answers, :points_earned, :integer
  end
end
