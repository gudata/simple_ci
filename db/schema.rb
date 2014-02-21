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

ActiveRecord::Schema.define(version: 20140215190846) do

  create_table "branches", force: true do |t|
    t.integer  "repository_id"
    t.string   "name"
    t.string   "image_uid"
    t.string   "canonical_name"
    t.string   "tip_oid"
    t.boolean  "build"
    t.string   "token"
    t.integer  "polling_interval"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "builds", force: true do |t|
    t.integer  "commit_id"
    t.string   "oid"
    t.integer  "state"
    t.datetime "started_at"
    t.datetime "finished_at"
    t.text     "push_data",   limit: 16777215
    t.text     "trace",       limit: 2147483647
    t.string   "before_oid"
    t.string   "tmp_file"
    t.integer  "pid"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "commits", force: true do |t|
    t.integer  "branch_id"
    t.integer  "committer_id"
    t.integer  "author_id"
    t.string   "oid"
    t.string   "image_uid"
    t.text     "message"
    t.datetime "time"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "developers", force: true do |t|
    t.string   "email"
    t.string   "name"
    t.string   "image_uid"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "repositories", force: true do |t|
    t.string   "name"
    t.string   "path"
    t.string   "image_uid"
    t.string   "email_recipients", default: "", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "scripts", force: true do |t|
    t.integer  "branch_id"
    t.string   "name"
    t.text     "body"
    t.integer  "timeout",    default: 1800, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
