module HasProgressBar
  extend ActiveSupport::Concern

  included do
  end

  def done_w
  	if color_status == 'green'
  		return 0
  	end

  	points_till_green = -(self.points_over_green)
	"#{(500 - points_till_green) / 5.0}%"
  end

  def wrong_w
  	"#{points_for(false) / 5.0}%"
  end

  def right_w(minus_incorrect = true)
  	pts = minus_incorrect ? (points_for(true) - points_for(false)) : points_for(true)
  	"#{pts / 5.0}%"
  end
end
