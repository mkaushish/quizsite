class Topic < ActiveRecord::Base
  attr_accessible :classroom_id, :user_id, :title, :description

  has_many :comments, :order => "created_at DESC",
  						:dependent => :destroy

  belongs_to :classroom
  belongs_to :user

  validates :title, :presence => :true
  auto_html_for :description do
        html_escape
        image
        youtube(:class => 'topic_you', :width => 400, :height => 250)
        link :target => "_blank", :rel => "nofollow"
        simple_format
  end
end