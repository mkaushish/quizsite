class Student < ActiveRecord::Base
  has_one :user,     :as => :identifiable, :dependent => :destroy
  has_many :quizzes, :as => :identifiable, :dependent => :destroy
  has_and_belongs_to_many :classrooms

  after_create :add_default_quizzes

  def self.quiz_type
    Quiz
  end

  def assign_classroom(c)
    # TODO improve me a little...
    classrooms << c # unless classrooms.find(c.id)
  end

  private

  # Add a default quiz for each chapter
  def add_default_quizzes
    CHAPTERS.each do |chapter|
      quizzes.create!(:problemtypes => Marshal.dump(chapter::PROBLEMS), :name => chapter.to_s)
    end
  end
end
