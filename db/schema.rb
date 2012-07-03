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

ActiveRecord::Schema.define(:version => 20120702100552) do

  create_table "classrooms", :force => true do |t|
    t.integer  "teacher_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "classrooms_students", :id => false, :force => true do |t|
    t.integer "classroom_id"
    t.integer "student_id"
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

  create_table "problemanswers", :force => true do |t|
    t.boolean  "correct"
    t.integer  "problem_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "response"
    t.integer  "user_id"
    t.string   "pclass"
  end

  add_index "problemanswers", ["user_id", "created_at"], :name => "index_problemanswers_on_user_id_and_created_at"
  add_index "problemanswers", ["user_id", "pclass", "created_at"], :name => "index_problemanswers_on_user_id_and_type_and_created_at"
  add_index "problemanswers", ["user_id"], :name => "index_problemanswers_on_user_id"

  create_table "problems", :force => true do |t|
    t.string   "problem"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "quizzes", :force => true do |t|
    t.binary   "problemtypes"
    t.integer  "student_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name"
  end

  create_table "students", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "teachers", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.string   "name"
    t.string   "email"
    t.string   "perms"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "encrypted_password"
    t.string   "salt"
    t.binary   "pscores"
    t.binary   "smartscores"
    t.string   "confirmation_code"
    t.boolean  "confirmed"
    t.integer  "identifiable_id"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true

end
