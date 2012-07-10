class Teacher < ActiveRecord::Base
  has_one :user,       :as => :identifiable, :dependent => :destroy
  has_many :homeworks, :as => :identifiable, :dependent => :destroy
  has_many :classrooms, :dependent => :destroy

  # we can't do below, afaik, but we don't want to anyway - every time we want a group of
  # students for a teacher, we will want the students associated with a certain classroom,
  # and if not we can just get the students manually
  # has_many :students, :through => :classrooms

  def self.quiz_type
    Homework
  end
end
