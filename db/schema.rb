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

ActiveRecord::Schema.define(version: 20140302195059) do

  create_table "badges_sashes", force: true do |t|
    t.integer  "badge_id"
    t.integer  "sash_id"
    t.boolean  "notified_user", default: false
    t.datetime "created_at"
  end

  add_index "badges_sashes", ["badge_id", "sash_id"], name: "index_badges_sashes_on_badge_id_and_sash_id"
  add_index "badges_sashes", ["badge_id"], name: "index_badges_sashes_on_badge_id"
  add_index "badges_sashes", ["sash_id"], name: "index_badges_sashes_on_sash_id"

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
    t.integer  "repository_id"
    t.string   "oid"
    t.integer  "state"
    t.datetime "started_at"
    t.datetime "finished_at"
    t.string   "total_time"
    t.text     "output",        limit: 2147483647
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
    t.boolean  "can_login", default: true
    t.string   "password_digest"
    t.string   "image_uid"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "sash_id"
    t.integer  "level",           default: 0
  end

  create_table "merit_actions", force: true do |t|
    t.integer  "user_id"
    t.string   "action_method"
    t.integer  "action_value"
    t.boolean  "had_errors",    default: false
    t.string   "target_model"
    t.integer  "target_id"
    t.boolean  "processed",     default: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "merit_activity_logs", force: true do |t|
    t.integer  "action_id"
    t.string   "related_change_type"
    t.integer  "related_change_id"
    t.string   "description"
    t.datetime "created_at"
  end

  create_table "merit_score_points", force: true do |t|
    t.integer  "score_id"
    t.integer  "num_points", default: 0
    t.string   "log"
    t.datetime "created_at"
  end

  create_table "merit_scores", force: true do |t|
    t.integer "sash_id"
    t.string  "category", default: "default"
  end

  create_table "repositories", force: true do |t|
    t.string   "name"
    t.string   "path"
    t.string   "image_uid"
    t.string   "git",              default: "git"
    t.integer  "display_order",    default: 100
    t.integer  "fetch_interval",   default: 60
    t.boolean  "auto_fetch"
    t.datetime "last_fetch"
    t.string   "email_recipients", default: "",    null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "sashes", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "scripts", force: true do |t|
    t.integer  "branch_id"
    t.string   "name"
    t.text     "body"
    t.integer  "state"
    t.integer  "timeout",    default: 1800, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
