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

ActiveRecord::Schema.define(version: 20150119020329) do

  create_table "crawling_errors", force: :cascade do |t|
    t.datetime "start_time"
    t.datetime "error_time"
    t.string   "keyword",    limit: 255
    t.text     "error_msg",  limit: 65535
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
  end

  create_table "crawling_googles", force: :cascade do |t|
    t.datetime "start_time"
    t.datetime "crawling_time"
    t.string   "keyword",       limit: 255
    t.integer  "_jobplanet",    limit: 4,   default: 0
    t.integer  "_jobkorea",     limit: 4,   default: 0
    t.integer  "_saramin",      limit: 4,   default: 0
    t.integer  "_incruit",      limit: 4,   default: 0
    t.datetime "created_at",                            null: false
    t.datetime "updated_at",                            null: false
  end

  create_table "crawling_missing_jobs", force: :cascade do |t|
    t.datetime "start_time"
    t.string   "keyword",    limit: 255
    t.integer  "is_done",    limit: 4,   default: 0
    t.datetime "created_at",                         null: false
    t.datetime "updated_at",                         null: false
  end

  create_table "crawling_navers", force: :cascade do |t|
    t.datetime "start_time"
    t.datetime "crawling_time"
    t.string   "keyword",              limit: 255
    t.integer  "_powerlink_jobplanet", limit: 4,   default: 0
    t.integer  "_powerlink_jobkorea",  limit: 4,   default: 0
    t.integer  "_powerlink_saramin",   limit: 4,   default: 0
    t.integer  "_powerlink_incruit",   limit: 4,   default: 0
    t.integer  "_bizsite_jobplanet",   limit: 4,   default: 0
    t.integer  "_bizsite_jobkorea",    limit: 4,   default: 0
    t.integer  "_bizsite_saramin",     limit: 4,   default: 0
    t.integer  "_bizsite_incruit",     limit: 4,   default: 0
    t.datetime "created_at",                                   null: false
    t.datetime "updated_at",                                   null: false
  end

end
