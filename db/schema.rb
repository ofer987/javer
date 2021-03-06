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

ActiveRecord::Schema.define(version: 20131006014010) do

  create_table "fichiers", force: true do |t|
    t.integer  "photo_id"
    t.integer  "photosize_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "fichiers", ["photo_id"], name: "index_fichiers_on_photo_id"
  add_index "fichiers", ["photosize_id"], name: "index_fichiers_on_photosize_id"

  create_table "photos", force: true do |t|
    t.integer  "user_id"
    t.string   "name",        default: "", null: false
    t.text     "description", default: "", null: false
    t.string   "filename",                 null: false
    t.datetime "taken_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "photos", ["user_id"], name: "index_photos_on_user_id"

  create_table "photosizes", force: true do |t|
    t.string   "name",       null: false
    t.integer  "width"
    t.integer  "height"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "user_types", force: true do |t|
    t.string   "name",       default: "", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "user_types_members", force: true do |t|
    t.integer  "user_id"
    t.text     "description", default: "", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "user_types_members", ["user_id"], name: "index_user_types_members_on_user_id"

  create_table "users", force: true do |t|
    t.integer  "user_type_id"
    t.string   "password_digest",              null: false
    t.string   "first_name",      default: "", null: false
    t.string   "last_name",       default: "", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "username"
  end

  add_index "users", ["user_type_id"], name: "index_users_on_user_type_id"

end
