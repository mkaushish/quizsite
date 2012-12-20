class RemoveDefunctColumns < ActiveRecord::Migration
  def up
    remove_column :quizzes, :type               if Quiz.columns_hash["type"]
    remove_column :users, :perms                if User.columns_hash["perms"]
    # remove_column :quiz_users, :num_attempts    if QuizUser.columns_hash["num_attempts"]
  end

  def down
    # THE REMOVE CALLS ABOVE ARE ACTUALLY REVERSIBLE, because they don't remove any info that's currently in use
  end
end
