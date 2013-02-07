class ClassroomQuiz < ActiveRecord::Base
  belongs_to :classroom
  belongs_to :quiz

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
end
