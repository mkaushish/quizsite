class HwAssignment < ActiveRecord::Base
  attr_accessible :classroom, :homework
  belongs_to :classroom
  belongs_to :homework
end
