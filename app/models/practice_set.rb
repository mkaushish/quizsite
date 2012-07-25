class PracticeSet < Quiz
  belongs_to :student, :foreign_key => 'user_id'
end
