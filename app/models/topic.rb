class Topic < ActiveRecord::Base
  attr_accessible :classroom_id, :user_id, :title, :description

  has_many :comments, :order => "created_at DESC",
  						:dependent => :destroy

  belongs_to :classroom
  belongs_to :user

  validates :title, :presence => :true
end