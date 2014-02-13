# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.


ActiveRecord::Schema.define(:version => 20140206112610) do

  create_table "answers", :force => true do |t|
    t.boolean  "correct"
    t.integer  "problem_id"
    t.binary   "response"
    t.integer  "problem_generator_id"
    t.float    "time_taken"
    t.integer  "user_id"
    t.string   "notepad"
    t.integer  "session_id"
    t.string   "session_type"
    t.integer  "problem_type_id"
    t.integer  "points"
    t.datetime "created_at",           :null => false
    t.datetime "updated_at",           :null => false
  end

  add_index "answers", ["user_id", "created_at"], :name => "index_answers_on_user_id_and_created_at"

  create_table "badges", :force => true do |t|
    t.integer  "student_id"
    t.string   "name"
    t.string   "badge_key"
    t.string   "image"
    t.integer  "level"
    t.integer  "answer_id"
    t.integer  "comment_id"
    t.integer  "teacher_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "classroom_assignments", :force => true do |t|
    t.integer  "classroom_id"
    t.integer  "student_id"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  add_index "classroom_assignments", ["classroom_id", "student_id"], :name => "index_classroom_assignments_on_classroom_id_and_student_id", :unique => true
  add_index "classroom_assignments", ["classroom_id"], :name => "index_classroom_assignments_on_classroom_id"
  add_index "classroom_assignments", ["student_id"], :name => "index_classroom_assignments_on_student_id"

  create_table "classroom_problem_sets", :force => true do |t|
    t.integer  "classroom_id"
    t.integer  "problem_set_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "starts_at"
    t.datetime "ends_at"
    t.boolean  "active",         :default => true
  end

  create_table "classroom_quizzes", :force => true do |t|
    t.integer  "classroom_id"
    t.integer  "quiz_id"
    t.datetime "starts_at"
    t.datetime "ends_at"
  end

  add_index "classroom_quizzes", ["classroom_id", "quiz_id"], :name => "classroom_quizzes_dual_index", :unique => true

  create_table "classroom_teachers", :force => true do |t|
    t.integer  "classroom_id", :null => false
    t.integer  "teacher_id",   :null => false
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  create_table "classrooms", :force => true do |t|
    t.string   "name"
    t.integer  "teacher_id"
    t.string   "student_password"
    t.string   "teacher_password"
    t.datetime "created_at",                          :null => false
    t.datetime "updated_at",                          :null => false
    t.integer  "badges_level_1_count", :default => 0
    t.integer  "badges_level_2_count", :default => 0
    t.integer  "badges_level_3_count", :default => 0
    t.integer  "badges_level_4_count", :default => 0
    t.integer  "badges_level_5_count", :default => 0
    t.integer  "badges_count",         :default => 0
    t.integer  "students_count"
    t.integer  "problem_sets_count"
    t.integer  "quizzes_count"
  end

  add_index "classrooms", ["name"], :name => "index_classrooms_on_name", :unique => true
  add_index "classrooms", ["student_password"], :name => "index_classrooms_on_student_password", :unique => true
  add_index "classrooms", ["teacher_password"], :name => "index_classrooms_on_teacher_password", :unique => true

  create_table "coaches", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "comments", :force => true do |t|
    t.text     "content"
    t.integer  "user_id"
    t.integer  "answer_id"
    t.integer  "classroom_id"
    t.integer  "reply_comment_id"
    t.integer  "topic_id"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
  end

  create_table "delayed_jobs", :force => true do |t|
    t.integer  "priority",   :default => 0, :null => false
    t.integer  "attempts",   :default => 0, :null => false
    t.text     "handler",                   :null => false
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.string   "queue"
    t.datetime "created_at",                :null => false
    t.datetime "updated_at",                :null => false
  end

  add_index "delayed_jobs", ["priority", "run_at"], :name => "delayed_jobs_priority"

  create_table "hw_assignments", :force => true do |t|
    t.integer "classroom_id"
    t.integer "homework_id"
  end

  create_table "lessons", :force => true do |t|
    t.integer  "classroom_id"
    t.integer  "teacher_id"
    t.datetime "start_time"
    t.datetime "end_time"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  create_table "news_feeds", :force => true do |t|
    t.integer  "user_id",         :null => false
    t.string   "content"
    t.string   "feed_type"
    t.integer  "problem_id"
    t.integer  "problem_set_id"
    t.integer  "problem_type_id"
    t.integer  "badge_id"
    t.integer  "quiz_id"
    t.integer  "comment_id"
    t.integer  "topic_id"
    t.integer  "answer_id"
    t.integer  "second_user_id"
    t.integer  "classroom_id"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  create_table "problem_generators", :force => true do |t|
    t.string   "klass"
    t.integer  "problem_type_id"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  create_table "problem_set_instances", :force => true do |t|
    t.integer  "user_id"
    t.integer  "problem_set_id"
    t.datetime "stop_green",     :default => '2014-02-04 05:01:47', :null => false
    t.integer  "num_red",        :default => 0
    t.integer  "num_green",      :default => 0
    t.integer  "num_blue",       :default => 0
    t.datetime "last_attempted"
    t.datetime "created_at",                                        :null => false
    t.datetime "updated_at",                                        :null => false
  end

  add_index "problem_set_instances", ["user_id", "problem_set_id"], :name => "problem_set_instances_user_problem_set", :unique => true

  create_table "problem_set_problems", :force => true do |t|
    t.integer  "problem_set_id"
    t.integer  "problem_type_id"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  add_index "problem_set_problems", ["problem_set_id", "problem_type_id"], :name => "problem_set_problems_problem_set_problem_type", :unique => true

  create_table "problem_set_stats", :force => true do |t|
    t.integer  "problem_set_instance_id"
    t.integer  "problem_type_id"
    t.integer  "points"
    t.datetime "last_attempted"
    t.integer  "problem_stat_id"
    t.integer  "current_problem_id"
    t.integer  "modifier",                :default => 0, :null => false
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
  end

  create_table "problem_sets", :force => true do |t|
    t.string   "name"
    t.integer  "user_id"
    t.text     "description"
    t.string   "video_link"
    t.datetime "created_at",                                 :null => false
    t.datetime "updated_at",                                 :null => false
    t.integer  "problem_set_problems_count",  :default => 0
    t.integer  "problem_set_instances_count", :default => 0
  end

  create_table "problem_stats", :force => true do |t|
    t.integer  "user_id"
    t.integer  "problem_type_id"
    t.integer  "count",           :default => 0
    t.integer  "correct",         :default => 0
    t.integer  "points",          :default => 0,                     :null => false
    t.integer  "points_wrong",    :default => 0,                     :null => false
    t.integer  "points_right",    :default => 100,                   :null => false
    t.datetime "stop_green",      :default => '2014-02-04 05:01:47', :null => false
    t.integer  "points_required", :default => 500
    t.datetime "created_at",                                         :null => false
    t.datetime "updated_at",                                         :null => false
    t.string   "color",           :default => "yellow"
  end

  add_index "problem_stats", ["user_id", "problem_type_id"], :name => "problem_stats_user_problem_type", :unique => true

  create_table "problem_types", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.string   "video_link"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  add_index "problem_types", ["name"], :name => "index_problem_types_on_name", :unique => true

  create_table "problems", :force => true do |t|
    t.binary   "serialized_problem"
    t.integer  "user_id"
    t.integer  "problem_generator_id"
    t.string   "body"
    t.text     "explanation"
    t.datetime "created_at",           :null => false
    t.datetime "updated_at",           :null => false
  end

  create_table "quiz_instances", :force => true do |t|
    t.integer  "quiz_id"
    t.integer  "user_id"
    t.datetime "last_attempted"
    t.datetime "started_at"
    t.datetime "ended_at"
    t.boolean  "complete"
    t.integer  "problem_set_instance_id"
    t.datetime "created_at",                                 :null => false
    t.datetime "updated_at",                                 :null => false
    t.boolean  "over_by_timer",           :default => false
    t.integer  "remaining_time"
    t.datetime "last_visited_at"
    t.boolean  "paused"
  end

  add_index "quiz_instances", ["quiz_id", "user_id"], :name => "index_quiz_instances_on_quiz_id_and_user_id", :unique => true
  add_index "quiz_instances", ["quiz_id"], :name => "index_quiz_instances_on_quiz_id"
  add_index "quiz_instances", ["user_id"], :name => "index_quiz_instances_on_user_id"

  create_table "quiz_problems", :force => true do |t|
    t.integer  "quiz_id"
    t.integer  "problem_type_id"
    t.integer  "count",            :default => 1
    t.boolean  "partial"
    t.string   "problem_category"
    t.integer  "problem_id"
    t.datetime "created_at",                      :null => false
    t.datetime "updated_at",                      :null => false
  end

  add_index "quiz_problems", ["quiz_id", "problem_type_id"], :name => "index_quiz_problems_on_quiz_id_and_problem_type_id"

  create_table "quiz_stats", :force => true do |t|
    t.integer  "quiz_instance_id"
    t.integer  "problem_type_id"
    t.integer  "remaining",        :default => 0
    t.integer  "total"
    t.integer  "problem_id"
    t.datetime "created_at",                      :null => false
    t.datetime "updated_at",                      :null => false
  end

  create_table "quizzes", :force => true do |t|
    t.string   "name"
    t.binary   "problemtypes"
    t.integer  "classroom_id"
    t.integer  "problem_set_id"
    t.string   "students"
    t.integer  "teacher_id"
    t.integer  "quiz_problems_count", :default => 0
    t.datetime "created_at",                         :null => false
    t.datetime "updated_at",                         :null => false
    t.datetime "start_time"
    t.datetime "end_time"
    t.integer  "limit"
    t.time     "timer"
    t.integer  "quiz_type"
  end

  add_index "quizzes", ["teacher_id", "name"], :name => "index_quizzes_on_teacher_id_and_name", :unique => true

  create_table "relationships", :force => true do |t|
    t.integer  "coach_id",   :null => false
    t.integer  "student_id", :null => false
    t.string   "relation",   :null => false
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "topics", :force => true do |t|
    t.string   "title"
    t.text     "description"
    t.integer  "user_id"
    t.integer  "classroom_id"
    t.integer  "comments_count", :default => 0
    t.datetime "created_at",                    :null => false
    t.datetime "updated_at",                    :null => false
  end

  create_table "users", :force => true do |t|
    t.string   "name"
    t.string   "email",                                   :null => false
    t.string   "encrypted_password"
    t.string   "salt"
    t.binary   "pscores"
    t.string   "confirmation_code"
    t.boolean  "confirmed",            :default => false
    t.integer  "points",               :default => 0
    t.string   "first_name"
    t.string   "last_name"
    t.string   "gender"
    t.string   "uid"
    t.string   "profile_link"
    t.string   "picture_link"
    t.string   "provider"
    t.string   "image"
    t.string   "confirmation_token"
    t.datetime "created_at",                              :null => false
    t.datetime "updated_at",                              :null => false
    t.string   "type"
    t.integer  "badges_level_1_count", :default => 0
    t.integer  "badges_level_2_count", :default => 0
    t.integer  "badges_level_3_count", :default => 0
    t.integer  "badges_level_4_count", :default => 0
    t.integer  "badges_level_5_count", :default => 0
    t.integer  "badges_count",         :default => 0
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true

end
