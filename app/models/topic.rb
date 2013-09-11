class Topic < ActiveRecord::Base
  attr_accessible :classroom_id, :user_id, :title, :description

  has_many :comments, :dependent => :destroy

  belongs_to :classroom
  belongs_to :user

  validates :title, :presence => :true
end