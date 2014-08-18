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

ActiveRecord::Schema.define(version: 20140817230302) do

  create_table "events", force: true do |t|
    t.date     "event_date"
    t.integer  "year"
    t.string   "event_type"
    t.string   "actor1"
    t.string   "actor2"
    t.integer  "interaction"
    t.string   "country"
    t.string   "source"
    t.text     "notes"
    t.integer  "total_fatalities"
    t.decimal  "latitude",         precision: 10, scale: 0
    t.decimal  "longitude",        precision: 10, scale: 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: true do |t|
    t.string   "email"
    t.string   "api_key"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
