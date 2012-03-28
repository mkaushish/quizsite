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

ActiveRecord::Schema.define(:version => 20120328073509) do

  create_table "problemanswers", :force => true do |t|
    t.boolean  "correct"
    t.integer  "problem_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "response"
    t.integer  "user_id"
    t.string   "type"
  end

  add_index "problemanswers", ["user_id", "created_at"], :name => "index_problemanswers_on_user_id_and_created_at"
  add_index "problemanswers", ["user_id", "type", "created_at"], :name => "index_problemanswers_on_user_id_and_type_and_created_at"
  add_index "problemanswers", ["user_id"], :name => "index_problemanswers_on_user_id"

  create_table "problems", :force => true do |t|
    t.string   "problem"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "quizzes", :force => true do |t|
    t.binary   "problemtypes"
    t.integer  "user_id"
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
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true

end
