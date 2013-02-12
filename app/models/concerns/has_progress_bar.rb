module HasProgressBar
  extend ActiveSupport::Concern

  included do
  end

  def done_w
  	if color_status == 'green'
  		0
  	elsif points_till_green > 250
  		"#{(500 - points_till_green) / 5.0}%"
  	else
  	end
  end

  def wrong_w
  end

  def right_w(minus_incorrect = true)
  end
end
