class AddProblemStatsToUsers < ActiveRecord::Migration
  def change
    # yes, I idiotically added all these columns during previous migrations, and they're not even in use... So, here they go!
    change_table :users do |t|
      t.rename :smartscores, :problem_stats
      t.remove :pscores
    end
  end
end
