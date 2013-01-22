# == Schema Information
#
# Table name: quizzes
#
#  id           :integer         not null, primary key
#  problemtypes :binary
#  user_id      :integer
#  created_at   :datetime
#  updated_at   :datetime
#  name         :string
#

class Quiz < ActiveRecord::Base
  has_many :quiz_instances
  has_many :users, :through => :quiz_instances

  has_many :quiz_problems
  has_many :problem_types, :through => :quiz_problems

  belongs_to :classroom

  # just do this when things are working a little better eh?
  # accepts_nested_attributes_for :problem_types

  attr_accessible :name, :problemtypes

  # validates :problemtypes, :presence => true

  validates :name, :presence => true,
                   :uniqueness => { :scope => :user_id, :message => "You can't name two quizzes the same thing" },
                   :length => { :within => 1..20 }

  after_create { allow_access(self.user_id) }
  after_save :set_problem_orders

  def assign(user)
    instance = quiz_instances.build(:user_id => user.id)
    return nil unless instance.save # if they already have an instance of this problem set it won't work
  end

  def add_problem_type(problem_type, count)
    !problem_type.nil? && quiz_problem_types.create(:problem_type => problem_type)
  end

  def remove_problem_type(problem_type)
    !problem_type.nil? && quiz_problem_types.where(:problem_type => problem_type).first.delete
  end

  def ptypes
    @ptypes ||= Marshal.load(self.problemtypes)
  end

  def idname
    return "quiz_#{self.id}"
  end

  # TODO implement thse two
  def hasSmartScore?
    return false
  end

  def smart_score
    return "?"
  end

  def allow_access(user)
    quiz_users.create!(:user => user)
  end

  def set_problem_orders
    quiz_users.each do |qu|
      qu.set_problem_order ptypes
    end
  end
end
