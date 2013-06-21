class AddColumnsToProblemTypes < ActiveRecord::Migration
  def change
  	add_column :problem_types, :description, :text
  	add_column :problem_types, :video_link, :string
  end
end
