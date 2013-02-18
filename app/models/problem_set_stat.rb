class ProblemSetStat < ActiveRecord::Base
  include CurrentProblem
  include FollowsProblemStat
  include HasProgressBar

  belongs_to :problem_type

  belongs_to :problem_set_instance
  delegate   :user, :to => :problem_set_instance

  validates :problem_set_instance, :presence => true

  before_create :assign_problem_stat #, :stop_green_now

  def update!(answer)
    self.problem_stat = stat.update!(answer)

    modify_points(answer.correct)

    change_problem

    if save
      self
    else
      $stderr.puts errors.full_messages
      nil
    end
  end

  def last_correct?
    modifier == 1
  end

  def points_till_green
    -(points_over_green)
  end

  def green?
    stop_green > Time.now
  end

  def set_yellow
    self.points_right = 85
    self.points_wrong = 30
  end

  def set_yellow!
    set_yellow
    return save
  end

  def color_status
    if green?
      'green'
    else
      ((points_wrong > 0) || (points_over_green > -450)) ? 'yellow' : 'red'
    end
  end

  def points_for(correct)
    if color_status == 'green'
      10
    else
      (multiplier(correct) * (correct ? points_right : points_wrong)).round
    end
  end

  def modify_points(correct)
    self.points_over_green += points_for(correct)

    if correct
      self.points_right = (points_right * 1.12)
      self.points_wrong -= 10
    else
      self.points_right -= 10
      self.points_wrong += 10
    end

    if points_over_green > 0
      set_stop_green
    end

    problem_set_instance.modify_green?(stop_green)
    set_multiplier(correct)

    self.points_wrong = 0 if points_wrong < 0
    self.points_wrong = 50 if points_wrong > 50
    self.points_right = 70 if points_right < 70

    self
  end

  def set_stop_green
    self.stop_green = Time.now + (60*60) * points_over_green
    self.points_over_green = 0
  end

  private
    def set_multiplier(correct)
      self.modifier = correct ? 1 : 0
    end

    def multiplier(correct)
      case modifier
      when 1
        correct ? 2.0 : 1.0
      when 2
        1.5
      else
        1.0
      end
    end

    def stop_green_now
      self.stop_green = Time.now
    end
end
