class ProblemStat < ActiveRecord::Base
  attr_accessible :user, :user_id, :problem_type, :problem_type_id

  belongs_to :user
  belongs_to :problem_type
  has_many :problem_generators, through: :problem_type
  has_many :answers, through: :problem_generators

  has_many :problem_set_stats
  has_many :quiz_stats

  validates :problem_type, :presence => true
  validates :user, :presence => true
  validates :count, :presence => true,
                    :numericality => { :only_integer => true,
                                       :greater_than_or_equal_to => 0 }
  validates :correct, :presence => true,
                      :numericality => { :only_integer => true,
                                         :greater_than_or_equal_to => 0 }

  has_many :quiz_problem_stats
  has_many :problem_set_stats

  has_many :answers, :finder_sql => proc { %Q{
    SELECT "answers".* FROM "answers" 
    WHERE "answers"."user_id" = #{user_id}
    AND "answers"."problem_type_id" = #{problem_type_id}
    ORDER BY created_at DESC
  } }

  def update_w_ans(answer, multiplier = 1.0)
    self.count += 1
    self.correct += 1 if answer.correct
    modify_rewards(answer.correct)
    self
  end

  def smart_score
    return "?" if count == 0
    return correct.to_f / count
  end

  def points_for(correct)
    return 10 if green?
    correct ? points_right : points_wrong
  end

  def modify_rewards(correct)
    if correct
      self.points_right = (points_right * 1.12)
      self.points_wrong -= 10
    else
      self.points_right -= 10
      self.points_wrong += 10
    end

    if points > 500
      set_stop_green
    end

    self.points_wrong = 0 if points_wrong < 0
    self.points_wrong = 50 if points_wrong > 50
    self.points_right = 70 if points_right < 70
    self.points_right = 500 if points_right > 500

    self
  end

  def green?
    stop_green > Time.now
  end

  def set_stop_green
    self.stop_green = Time.now + (60*60) * points_over_green
  end

  def points_till_green
    500 - points
  end

  def points_over_green
    points - 500
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
      # 89 means if you fail once and succeed next time it becomes yellow (90 poins)
      ((points_wrong > 0) || (points > 89)) ? 'yellow' : 'red'
    end
  end
end
