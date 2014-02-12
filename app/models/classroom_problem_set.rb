class ClassroomProblemSet < ActiveRecord::Base
  belongs_to :classroom, counter_cache: :problem_sets_count
  belongs_to :problem_set

  scope :only_active, where("active = ?", true)
  scope :only_inactive, where("active = ?", false)
end