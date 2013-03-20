class AddProblemTypeToAnswers < ActiveRecord::Migration
  def up
    add_column :answers, :problem_type_id, :integer
    remove_column :answers, :pclass
    answers = Answer.includes(:problem_generator).all 

    puts "setting problem_type_ids"
    answers.each do |ans|
      ans.problem_type_id = ans.problem_generator.problem_type_id
      print ans.save ? "+":"-"
    end
  end

  def down
    add_column :answers, :pclass, :string
    remove_column :answers, :problem_type_id
  end
end
