module HasProgressBar
  extend ActiveSupport::Concern

  def done_p
  	if color_status == 'green'
  		return 0
  	end
    total = self.problem_stat.points_required - points_till_green
	  to_percent (total)
    
  end

  def wrong_p
  	to_percent points_for(false)
  end

  def wrong_p_remaining 
    to_percent [points_till_green, points_for(false)].min
  end

  def right_p(minus_incorrect = true)
  	pts = minus_incorrect ? (points_for(true) - points_for(false)) : points_for(true)
    to_percent pts
  end

  def right_p_remaining
    [100 - done_p - wrong_p_remaining, right_p].min
  end

  def remaining_p
    to_percent (points_till_green - points_for(correct))
  end

  private
    def to_percent(pts)
      pts / (self.problem_stat.points_required / 100.0)
    end


############################################################################

  # def done_p
  #   if color_status == 'blue'
  #     return 0
  #   end

  #   to_percent (500 - points_till_green)
  # end

  # def wrong_p
  #   to_percent points_for(false)
  # end

  # def wrong_p_remaining 
  #   to_percent [points_till_blue, points_for(false)].min
  # end

  # def right_p(minus_incorrect = true)
  #   pts = minus_incorrect ? (points_for(true) - points_for(false)) : points_for(true)
  #   to_percent pts
  # end

  # def right_p_remaining
  #   [100 - done_p - wrong_p_remaining, right_p].min
  # end

  # def remaining_p
  #   to_percent (points_till_blue - points_for(correct))
  # end
end
