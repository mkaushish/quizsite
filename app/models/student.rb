class Student < ActiveRecord::Base
  has_one :user, :as => :identifiable
  has_many :quizzes
end
