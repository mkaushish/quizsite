class ClassroomQuiz < ActiveRecord::Base
  belongs_to :classroom, counter_cache: :quizzes_count
  belongs_to :quiz

  after_create :send_news_feed_to_classroom_students

  def assign(start_time, end_time)
    self.starts_at = start_time
    self.ends_at = end_time
  end

  def assigned?
    !starts_at.nil? && !ends_at.nil?
  end

  def assigned_status
    if !self.assigned?
      "<i class=status>Unassigned</i>".html_safe
    elsif starts_at > Time.now
      "<i class=status>Scheduled</i> to start <i class=status>#{starts_at}</i>".html_safe
    elsif ends_at < Time.now
      "<i class=status>Completed</i> at <i class=status>#{ends_at}</i>, by <i class=status>#{}</i>".html_safe
    else
      "<i class=status>Due</i> <i class=status>#{ends_at}</i>: completed by " +
        "<i class=status>#{0} / #{quiz_instances.length}</i>".html_safe
    end
  end

  private
  
  def send_news_feed_to_classroom_students
    students = self.classroom.students
    students.each do |student|
      student.news_feeds.create(:content => "You have been assigned a new quiz #{self.quiz.name}!!", :feed_type => "quiz", :user_id => student.id, :quiz_id => self.quiz_id)
    end      
  end
end