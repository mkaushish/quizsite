module HasProgressBar
  extend ActiveSupport::Concern

  def done_w
  	if color_status == 'green'
  		return 0
  	end

    if points_till_green < points_for(correct)
      points_till_green = points_for(correct)
    end
	  to_w (500 - points_till_green)
  end

  def wrong_w
  	to_w points_for(false)
  end

  def right_w(minus_incorrect = true)
  	pts = minus_incorrect ? (points_for(true) - points_for(false)) : points_for(true)
    to_w pts
  end

  def remaining_w
    to_w (points_till_green - points_for(correct))
  end

  private
    def to_w(pts)
      "#{pts / 5.0}%"
    end
end
