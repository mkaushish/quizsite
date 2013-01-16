module CurrentProblem
  extend ActiveSupport::Concern

  included do
    belongs_to :current_problem, :class_name => "Problem"
  end

  def spawn_problem
    return self.current_problem if self.current_problem

    self.current_problem = problem_type.spawn
    save!
    self.current_problem
  end

  def change_problem
    self.current_problem = nil
  end
end
