class CreateNewsFeeds < ActiveRecord::Migration
  def change
    create_table :news_feeds do |t|
      t.integer   :user_id, :null => false
      t.string    :content
      t.string    :feed_type
      t.integer   :problem_id
      t.integer   :problem_set_id
      t.integer   :problem_type_id
      t.integer   :badge_id
      t.integer   :quiz_id
      t.integer   :comment_id
      t.integer   :topic_id
      t.integer   :answer_id
      t.integer   :second_user_id
      t.integer   :classroom_id
      
      t.timestamps
    end
  end
end
