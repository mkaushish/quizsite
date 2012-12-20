class UserStat < ActiveRecord::Base
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

  def update!(was_correct)
    self.count += 1
    self.correct += 1 if was_correct
    save
  end
end
