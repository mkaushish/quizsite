class QuizInstance < ActiveRecord::Base
    
    belongs_to :quiz
    belongs_to :user
  
    belongs_to :problem_set_instance
    
    has_one :problem_set, :through => :problem_set_instance

    has_many :quiz_stats, :dependent => :destroy
    has_many :quiz_problems, :through => :quiz

    has_many :stats_remaining, :class_name => "QuizStat", 
                             :conditions => "remaining > 0", 
                             :dependent => :destroy
    has_many :answers,  :as => :session,
                      :dependent => :destroy

    validates :user, :presence => true
    validates :quiz, :presence => true

    delegate :name, :idname, :to => :problem_set

    def start
        if !self.complete.nil?
            return false
        end

        self.complete = false
        self.started_at = Time.now
        self.paused = false
        self.quiz_stats.create quiz.stat_attrs

        # the ! makes it return false if it doesn't save
        save || !self.quiz_stats.destroy_all
    end

    def started?
        !self.complete.nil?
    end

    def finish
        self.ended_at = Time.now
        self.complete = true
        self.save
    end

    def finished?
        self.complete == true
    end
  
    def over?
        stats_remaining.empty?
    end

    def next_stat
        @next_stat ||= stats_remaining.first
    end

    def next_problem
        next_stat.spawn_problem
    end

    def stats
        self.quiz_stats 
    end

    def update_last_visited
        self.last_visited_at = Time.now.utc 
        # self.save
    end

    def update_timer_and_last_visited
        old_last_visited_at = self.last_visited_at
        new_last_visited_at = update_last_visited
        self.remaining_time -= ( new_last_visited_at - old_last_visited_at ).round unless self.paused
        self.paused = false
        self.save
    end

    def problems_left
        problems_left = Array.new
        problem_ids = self.quiz_problems.pluck(:problem_id) - self.answers.pluck(:problem_id)
        problem_ids.each do |problem_id|
            problems_left.push Problem.find_by_id(problem_id).to_s
        end
        return problems_left
    end

    def send_submission_notification_to_teacher(student)
        quiz = self.quiz
        classroom = quiz.classroom
        unless classroom.blank?
            teacher = classroom.teachers.first
            user_check = teacher.news_feeds.where("quiz_id = ? AND second_user_id = ?", quiz_id, student.id)
            if  user_check.blank?
                notifications = teacher.news_feeds.where("quiz_id = ?", quiz_id)
                if  notifications.blank?
                    notifications_count = notifications.count
                    notifications.destroy_all unless notifications_count == 0
                    notifications_count += 1
                    student_word = "student".pluralize(notifications_count)
                    new_notification = teacher.news_feeds.create(:content => "#{notifications_count} #{student_word} has submitted quiz", :feed_type => "Quiz Submission", :second_user_id => student.id, :quiz_id => quiz.id)
                end
            end
        end
    end
end