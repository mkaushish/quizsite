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

ActiveRecord::Schema.define(:version => 20130723115135) do

  create_table "active_admin_comments", :force => true do |t|
    t.string   "resource_id",   :null => false
    t.string   "resource_type", :null => false
    t.integer  "author_id"
    t.string   "author_type"
    t.text     "body"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
    t.string   "namespace"
  end

  add_index "active_admin_comments", ["author_type", "author_id"], :name => "index_active_admin_comments_on_author_type_and_author_id"
  add_index "active_admin_comments", ["namespace"], :name => "index_active_admin_comments_on_namespace"
  add_index "active_admin_comments", ["resource_type", "resource_id"], :name => "index_admin_notes_on_resource_type_and_resource_id"

  create_table "admin_users", :force => true do |t|
    t.string   "email",                  :default => "", :null => false
    t.string   "encrypted_password",     :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
  end

  add_index "admin_users", ["email"], :name => "index_admin_users_on_email", :unique => true
  add_index "admin_users", ["reset_password_token"], :name => "index_admin_users_on_reset_password_token", :unique => true

  create_table "answers", :force => true do |t|
    t.boolean  "correct"
    t.integer  "problem_id"
    t.binary   "response"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
    t.float    "time_taken"
    t.string   "notepad"
    t.integer  "problem_generator_id"
    t.integer  "session_id"
    t.string   "session_type"
    t.integer  "problem_type_id"
    t.integer  "points"
  end

  add_index "answers", ["user_id", "created_at"], :name => "index_problemanswers_on_user_id_and_created_at"
  add_index "answers", ["user_id"], :name => "index_problemanswers_on_user_id"

  create_table "badges", :force => true do |t|
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.integer  "student_id"
    t.string   "name"
    t.string   "badge_key"
    t.integer  "level"
  end

  create_table "classroom_assignments", :force => true do |t|
    t.integer "classroom_id"
    t.integer "student_id"
  end

  add_index "classroom_assignments", ["classroom_id", "student_id"], :name => "index_class_assignments_on_classroom_id_and_student_id", :unique => true
  add_index "classroom_assignments", ["classroom_id"], :name => "index_class_assignments_on_classroom_id"
  add_index "classroom_assignments", ["student_id"], :name => "index_class_assignments_on_student_id"

  create_table "classroom_problem_sets", :force => true do |t|
    t.integer  "classroom_id"
    t.integer  "problem_set_id"
    t.datetime "starts_at"
    t.datetime "ends_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "classroom_problem_sets", ["classroom_id", "problem_set_id"], :name => "index_hw_assignments_on_classroom_id_and_homework_id", :unique => true
  add_index "classroom_problem_sets", ["classroom_id"], :name => "index_hw_assignments_on_classroom_id"
  add_index "classroom_problem_sets", ["problem_set_id"], :name => "index_hw_assignments_on_homework_id"

  create_table "classroom_quizzes", :force => true do |t|
    t.integer  "classroom_id"
    t.integer  "quiz_id"
    t.integer  "teacher_id"
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
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "student_password"
    t.string   "teacher_password"
  end

  create_table "coaches", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "delayed_jobs", :force => true do |t|
    t.integer  "priority",   :default => 0
    t.integer  "attempts",   :default => 0
    t.text     "handler"
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.string   "queue"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "delayed_jobs", ["priority", "run_at"], :name => "delayed_jobs_priority"

  create_table "news_feeds", :force => true do |t|
    t.integer  "user_id",         :null => false
    t.string   "content"
    t.string   "feed_type"
    t.integer  "problem_id"
    t.integer  "problem_set_id"
    t.integer  "problem_type_id"
    t.integer  "badge_id"
    t.integer  "quiz_id"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  create_table "problem_generators", :force => true do |t|
    t.string  "klass"
    t.integer "problem_type_id"
  end

  create_table "problem_set_instances", :force => true do |t|
    t.integer  "user_id"
    t.integer  "problem_set_id"
    t.datetime "last_attempted"
    t.datetime "stop_green",     :default => '2013-02-11 00:56:57', :null => false
    t.integer  "num_blue"
    t.integer  "num_green"
    t.integer  "num_red"
  end

  add_index "problem_set_instances", ["user_id", "problem_set_id"], :name => "problem_set_instances_by_user", :unique => true

  create_table "problem_set_problems", :force => true do |t|
    t.integer "problem_set_id"
    t.integer "problem_type_id"
  end

  add_index "problem_set_problems", ["problem_set_id", "problem_type_id"], :name => "problem_set_problem_types_index", :unique => true

  create_table "problem_set_stats", :force => true do |t|
    t.integer "problem_set_instance_id"
    t.integer "problem_type_id"
    t.integer "problem_stat_id"
    t.integer "current_problem_id"
    t.integer "modifier",                :default => 0, :null => false
  end

  create_table "problem_sets", :force => true do |t|
    t.string  "name"
    t.integer "user_id"
    t.string  "image"
    t.string  "description"
    t.string  "video_link"
  end

  create_table "problem_stats", :force => true do |t|
    t.integer  "user_id"
    t.integer  "problem_type_id"
    t.integer  "count",           :default => 0
    t.integer  "correct",         :default => 0
    t.integer  "points",          :default => 0,                     :null => false
    t.integer  "points_wrong",    :default => 0,                     :null => false
    t.integer  "points_right",    :default => 100,                   :null => false
    t.datetime "stop_green",      :default => '2013-03-14 12:24:57', :null => false
  end

  add_index "problem_stats", ["user_id", "problem_type_id"], :name => "index_problem_stats_on_user_id_and_problem_type_id", :unique => true

  create_table "problem_types", :force => true do |t|
    t.string "name"
    t.text   "description"
    t.string "video_link"
  end

  add_index "problem_types", ["name"], :name => "index_problem_types_on_name", :unique => true

  create_table "problems", :force => true do |t|
    t.binary   "serialized_problem"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "problem_generator_id"
    t.integer  "user_id"
  end

  create_table "quiz_instances", :force => true do |t|
    t.integer  "quiz_id"
    t.integer  "user_id"
    t.datetime "last_attempted"
    t.datetime "started_at"
    t.datetime "ended_at"
    t.boolean  "complete"
    t.integer  "problem_set_instance_id"
  end

  add_index "quiz_instances", ["quiz_id", "user_id"], :name => "index_quiz_users_on_quiz_id_and_user_id", :unique => true
  add_index "quiz_instances", ["quiz_id"], :name => "index_quiz_users_on_quiz_id"
  add_index "quiz_instances", ["user_id"], :name => "index_quiz_users_on_user_id"

  create_table "quiz_problems", :force => true do |t|
    t.integer "quiz_id"
    t.integer "problem_type_id"
    t.integer "count",            :default => 1
    t.boolean "partial"
    t.string  "problem_category"
    t.integer "problem"
  end

  add_index "quiz_problems", ["quiz_id", "problem_type_id"], :name => "index_quiz_problems_on_quiz_id_and_problem_type_id"

  create_table "quiz_stats", :force => true do |t|
    t.integer "quiz_instance_id"
    t.integer "problem_type_id"
    t.integer "remaining",        :default => 0
    t.integer "total"
  end

  create_table "quizzes", :force => true do |t|
    t.binary   "problemtypes"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name"
    t.integer  "classroom_id"
    t.integer  "problem_set_id"
  end

  add_index "quizzes", ["user_id", "name"], :name => "index_quizzes_on_user_id_and_name", :unique => true

  create_table "relationships", :force => true do |t|
    t.integer  "coach_id"
    t.integer  "student_id"
    t.string   "relation"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "users", :force => true do |t|
    t.string   "name"
    t.string   "email"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "encrypted_password"
    t.string   "salt"
    t.string   "confirmation_code"
    t.boolean  "confirmed",              :default => false
    t.string   "type"
    t.integer  "points",                 :default => 0
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.string   "authentication_token"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "gender"
    t.string   "uid"
    t.string   "profile_link"
    t.string   "picture_link"
    t.string   "provider"
    t.string   "image"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true

end
