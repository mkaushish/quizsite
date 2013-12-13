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

    after_create :send_notification_to_students_if_owner_is_teacher
    
    private

    def send_notification_to_students_if_owner_is_teacher
        if self.user.is_a? Teacher
            _classroom = self.classroom
            _students = _classroom.students
            unless _students.blank?
                _students.each do |student|
                    student.news_feeds.create(:content => "Your Teacher #{self.user.name} has created a topic #{topic.title}", :feed_type => "Teacher created Topic")
                end
            end
        end
    end
end