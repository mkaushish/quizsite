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

ActiveRecord::Schema.define(:version => 20120706175301) do

  create_table "classrooms", :force => true do |t|
    t.string   "name",       :limit => nil
    t.integer  "teacher_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "classrooms_homeworks", :id => false, :force => true do |t|
    t.integer "classroom_id"
    t.integer "homework_id"
  end

  create_table "classrooms_students", :id => false, :force => true do |t|
    t.integer "classroom_id"
    t.integer "student_id"
  end

  create_table "delayed_jobs", :force => true do |t|
    t.integer  "priority",                  :default => 0
    t.integer  "attempts",                  :default => 0
    t.text     "handler"
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by",  :limit => nil
    t.string   "queue",      :limit => nil
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "delayed_jobs", ["priority", "run_at"], :name => "delayed_jobs_priority"

  create_table "problemanswers", :force => true do |t|
    t.boolean  "correct"
    t.integer  "problem_id"
    t.binary   "response"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
    t.string   "pclass",     :limit => nil
  end

  add_index "problemanswers", ["user_id", "created_at"], :name => "index_problemanswers_on_user_id_and_created_at"
  add_index "problemanswers", ["user_id", "pclass", "created_at"], :name => "index_problemanswers_on_user_id_and_pclass_and_created_at"
  add_index "problemanswers", ["user_id"], :name => "index_problemanswers_on_user_id"

  create_table "problems", :force => true do |t|
    t.binary   "problem"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "quizzes", :force => true do |t|
    t.binary   "problemtypes"
    t.integer  "identifiable_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name",              :limit => nil
    t.string   "identifiable_type", :limit => 15
  end

  add_index "quizzes", ["identifiable_id", "name"], :name => "index_quizzes_on_identifiable_id_and_name", :unique => true

  create_table "students", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "teachers", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.string   "name",               :limit => nil
    t.string   "email",              :limit => nil
    t.string   "perms",              :limit => nil
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "encrypted_password", :limit => nil
    t.string   "salt",               :limit => nil
    t.binary   "pscores"
    t.binary   "smartscores"
    t.string   "confirmation_code",  :limit => nil
    t.boolean  "confirmed",                         :default => false
    t.integer  "identifiable_id"
    t.string   "identifiable_type",  :limit => nil
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true

end
