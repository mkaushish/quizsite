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

ActiveRecord::Schema.define(:version => 20120905172408) do

  create_table "class_assignments", :force => true do |t|
    t.integer "classroom_id"
    t.integer "student_id"
  end

  add_index "class_assignments", ["classroom_id", "student_id"], :name => "index_class_assignments_on_classroom_id_and_student_id", :unique => true
  add_index "class_assignments", ["classroom_id"], :name => "index_class_assignments_on_classroom_id"
  add_index "class_assignments", ["student_id"], :name => "index_class_assignments_on_student_id"

  create_table "classrooms", :force => true do |t|
    t.string   "name"
    t.integer  "teacher_id"
    t.datetime "created_at"
    t.datetime "updated_at"
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

  create_table "hw_assignments", :force => true do |t|
    t.integer "classroom_id"
    t.integer "homework_id"
  end

  add_index "hw_assignments", ["classroom_id", "homework_id"], :name => "index_hw_assignments_on_classroom_id_and_homework_id", :unique => true
  add_index "hw_assignments", ["classroom_id"], :name => "index_hw_assignments_on_classroom_id"
  add_index "hw_assignments", ["homework_id"], :name => "index_hw_assignments_on_homework_id"

  create_table "problemanswers", :force => true do |t|
    t.boolean  "correct"
    t.integer  "problem_id"
    t.binary   "response"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
    t.string   "pclass"
    t.float    "time_taken"
    t.string   "notepad"
  end

  add_index "problemanswers", ["user_id", "created_at"], :name => "index_problemanswers_on_user_id_and_created_at"
  add_index "problemanswers", ["user_id", "pclass", "created_at"], :name => "index_problemanswers_on_user_id_and_pclass_and_created_at"
  add_index "problemanswers", ["user_id"], :name => "index_problemanswers_on_user_id"

  create_table "problems", :force => true do |t|
    t.binary   "serialized_problem"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
  end

  create_table "quiz_users", :force => true do |t|
    t.integer "quiz_id"
    t.integer "user_id"
    t.string  "s_problem_order"
    t.integer "problem_id",      :default => -1
    t.integer "num_attempts",    :default => 0
  end

  add_index "quiz_users", ["quiz_id", "user_id"], :name => "index_quiz_users_on_quiz_id_and_user_id", :unique => true
  add_index "quiz_users", ["quiz_id"], :name => "index_quiz_users_on_quiz_id"
  add_index "quiz_users", ["user_id"], :name => "index_quiz_users_on_user_id"

  create_table "quizzes", :force => true do |t|
    t.binary   "problemtypes"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name"
    t.string   "type"
  end

  add_index "quizzes", ["user_id", "name"], :name => "index_quizzes_on_user_id_and_name", :unique => true

  create_table "users", :force => true do |t|
    t.string   "name"
    t.string   "email"
    t.string   "perms"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "encrypted_password"
    t.string   "salt"
    t.binary   "problem_stats"
    t.string   "confirmation_code"
    t.boolean  "confirmed",          :default => false
    t.string   "type"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true

end
