class AddProblemTypesTable < ActiveRecord::Migration
  def change
    create_table :problem_types do |t|
      t.string :name
    end
    add_index :problem_types, :name, :unique => true

    create_table :problem_generators do |t|
      t.string :klass
      t.references :problem_type
    end

    create_table :problem_stats do |t|
      t.integer :user_id
      t.integer :problem_type_id
      t.integer :count, :default => 0
      t.integer :correct, :default => 0
    end
    add_index :problem_stats, [ :user_id, :problem_type_id ], :unique => true
              #:name => :problem_stats_user_problem_type_index

    # TODO
    # remove_column :problemanswers, :pclass
    add_column :problemanswers, :problem_generator_id, :integer
    # userID should never have been there really
    rename_column :problems, :user_id, :problem_generator_id
  end
end
