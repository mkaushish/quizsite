class Classroom < ActiveRecord::Base
  attr_accessible :name
  has_and_belongs_to_many :students
  has_and_belongs_to_many :homeworks
  belongs_to :teacher

  def assign!(hw)
    homeworks.create!(hw.id)
  end
end
