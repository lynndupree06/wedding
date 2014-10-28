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
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20141028073100) do

  create_table "groups", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "groups_guests", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "group_id"
    t.integer  "guest_id"
  end

  create_table "guests", force: true do |t|
    t.string   "last_name"
    t.string   "first_name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "title"
    t.string   "suffix"
    t.integer  "party_id"
    t.string   "gender"
    t.boolean  "child"
    t.string   "meal_option"
    t.integer  "table"
  end

  create_table "parties", force: true do |t|
    t.string   "name"
    t.string   "outer_envelop"
    t.string   "inner_envelop"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "address"
    t.string   "city"
    t.string   "state"
    t.string   "postal_code"
    t.string   "country"
    t.string   "email"
    t.string   "a_b_list"
    t.boolean  "rsvp"
    t.integer  "size"
    t.boolean  "save_the_date_sent"
    t.string   "notes"
    t.string   "key"
    t.boolean  "confirmed"
    t.boolean  "rsvp_dinner"
    t.boolean  "rsvp_brunch"
    t.integer  "size_rehearsal"
    t.integer  "size_brunch"
  end

  create_table "photos", force: true do |t|
    t.string   "desc"
    t.string   "category"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: true do |t|
    t.string   "name"
    t.string   "email"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true

end
