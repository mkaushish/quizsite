class ProblemStat < ActiveRecord::Base
  attr_accessible :user, :user_id, :problem_type, :problem_type_id

  belongs_to :user
  belongs_to :problem_type

  validates :problem_type, :presence => true
  validates :user, :presence => true
  validates :count, :presence => true,
                    :numericality => { :only_integer => true,
                                       :greater_than_or_equal_to => 0 }
  validates :correct, :presence => true,
                      :numericality => { :only_integer => true,
                                         :greater_than_or_equal_to => 0 }

  has_many :quiz_problem_stats
  has_many :problem_set_stats

  def update!(was_correct)
    self.count += 1
    self.correct += 1 if was_correct
    save
    self
  end

  def smart_score
    return "?" if count == 0
    return correct.to_f / count
  end

  def calculate_points(answer)
    return 5
  end
end
