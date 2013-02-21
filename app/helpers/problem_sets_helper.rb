module ProblemSetsHelper
  def print_ps(problem_set)
    "<b class=problem_set>#{problem_set.name}</b>".html_safe
  end

  def prog_bar_px(percent, num_notifiers)
    w = (percent * (7.2 - 0.01 * num_notifiers)).round
    # puts "prog_bar_px", "\t#{percent}", "\t#{w}"
    "#{w}px" # max 7
  end

  def complete_tip
    "#{500 - @stat.points_till_green} points earned"
  end

  def remaining_tip
    "#{@stat.points_till_green} points till green"
  end

  def right_tip
    "#{@stat.points_for(true)} points for a right answer"
  end

  def wrong_tip
    "#{@stat.points_for(false)} points for a wrong answer"
  end
end
