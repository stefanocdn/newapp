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

ActiveRecord::Schema.define(:version => 20131030162302558) do

  create_table "categories", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "categorizations", :force => true do |t|
    t.integer  "lesson_id"
    t.integer  "category_id"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  add_index "categorizations", ["category_id"], :name => "index_categorizations_on_category_id"
  add_index "categorizations", ["lesson_id"], :name => "index_categorizations_on_lesson_id"

  create_table "groups", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "groups", ["name"], :name => "index_groups_on_name", :unique => true

  create_table "lessons", :force => true do |t|
    t.string   "title"
    t.text     "content"
    t.decimal  "price"
    t.integer  "user_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.string   "address"
    t.float    "latitude"
    t.float    "longitude"
  end

  create_table "memberships", :force => true do |t|
    t.integer  "user_id"
    t.integer  "group_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "memberships", ["group_id"], :name => "index_memberships_on_group_id"
  add_index "memberships", ["user_id", "group_id"], :name => "index_memberships_on_user_id_and_group_id", :unique => true
  add_index "memberships", ["user_id"], :name => "index_memberships_on_user_id"

  create_table "messages", :force => true do |t|
    t.integer  "user_id"
    t.string   "subject"
    t.string   "body"
    t.boolean  "sent"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
    t.integer  "sender_id"
    t.integer  "recipient_id"
  end

  add_index "messages", ["user_id", "created_at"], :name => "index_messages_on_user_id_and_created_at"

  create_table "reviews", :force => true do |t|
    t.integer  "reviewer_id"
    t.integer  "reviewed_id"
    t.text     "content"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
    t.integer  "rating"
  end

  add_index "reviews", ["reviewed_id", "created_at"], :name => "index_reviews_on_reviewed_id_and_created_at"
  add_index "reviews", ["reviewed_id"], :name => "index_reviews_on_reviewed_id"
  add_index "reviews", ["reviewer_id", "created_at"], :name => "index_reviews_on_reviewer_id_and_created_at"
  add_index "reviews", ["reviewer_id"], :name => "index_reviews_on_reviewer_id"

  create_table "scholarships", :force => true do |t|
    t.integer  "user_id"
    t.integer  "school_id"
    t.date     "start_date"
    t.date     "end_date"
    t.string   "degree"
    t.string   "field"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "scholarships", ["school_id"], :name => "index_scholarships_on_school_id"
  add_index "scholarships", ["user_id", "school_id"], :name => "index_scholarships_on_user_id_and_school_id", :unique => true
  add_index "scholarships", ["user_id"], :name => "index_scholarships_on_user_id"

  create_table "schools", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "users", :force => true do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "email"
    t.datetime "created_at",                         :null => false
    t.datetime "updated_at",                         :null => false
    t.string   "password_digest"
    t.string   "remember_token"
    t.boolean  "admin",           :default => false
    t.string   "avatar"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["remember_token"], :name => "index_users_on_remember_token"

end
