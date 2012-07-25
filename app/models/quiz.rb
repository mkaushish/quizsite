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
  @@name_regex = /[a-zA-Z0-9 ]+/
  has_many :quiz_users
  has_many :users, :through => :quiz_users

  attr_accessible :name, :problemtypes

  validates :problemtypes, :presence => true

  validates :name,         :presence => true,
                           :uniqueness => { :scope => :user_id, :message => "You can't name two homeworks the same thing" },
                           :length => { :within => 1..20 },
                           :format => { :with => @@name_regex, :message => "Only letters and numbers allowed" }

  after_create { allow_access(self.user_id) }
  after_save :set_problem_orders

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

  def smartScore
    return "?"
  end

  def allow_access(my_user)
    # $stderr.puts "\n" + "#"*100
    my_user_id = -1
    if my_user.kind_of?(User) || my_user.kind_of?(Student)
      my_user_id = my_user.id
    elsif my_user.is_a?(Fixnum)
      my_user_id = my_user
    else
      $stderr.puts "can only allow access to my_users, not #{my_user.inspect}"
      return
    end

    # $stderr.puts "checking user_id => #{my_user_id}"

    if quiz_users.where(:user_id => my_user_id).empty?
     # $stderr.puts "creating quiz user with user_id => #{my_user_id}, order => #{ptypes}"
      quiz_users.create!(:user_id => my_user_id, :problem_order => ptypes)
    end
  end

  def set_problem_orders
    quiz_users.each do |qu|
      qu.set_problem_order ptypes
    end
  end
end
