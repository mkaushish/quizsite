class Student < ActiveRecord::Base
  has_one :user,     :as => :identifiable, :dependent => :destroy
  has_many :quizzes, :as => :identifiable, :dependent => :destroy

  after_create :add_default_quizzes

  private

  def self.quiz_type
    Quiz
  end

  # Add a default quiz for each chapter
  def add_default_quizzes
    CHAPTERS.each do |chapter|
      quizzes.create!(:problemtypes => Marshal.dump(chapter::PROBLEMS), :name => chapter.to_s)
    end
  end
end
