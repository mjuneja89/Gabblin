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

ActiveRecord::Schema.define(version: 20161025111507) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "comments", force: :cascade do |t|
    t.text     "body"
    t.integer  "user_id"
    t.integer  "post_id"
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
    t.integer  "hearts_count", default: 0
    t.integer  "parent_id"
    t.integer  "coin_count",   default: 0
  end

  add_index "comments", ["post_id"], name: "index_comments_on_post_id", using: :btree
  add_index "comments", ["user_id", "post_id", "created_at"], name: "index_comments_on_user_id_and_post_id_and_created_at", using: :btree
  add_index "comments", ["user_id"], name: "index_comments_on_user_id", using: :btree

  create_table "communities", force: :cascade do |t|
    t.string   "name"
    t.integer  "user_id"
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
    t.text     "description"
    t.integer  "posts_count", default: 0, null: false
    t.string   "cpic"
    t.integer  "postcount",   default: 0, null: false
    t.string   "slug"
  end

  add_index "communities", ["slug"], name: "index_communities_on_slug", unique: true, using: :btree
  add_index "communities", ["user_id", "created_at"], name: "index_communities_on_user_id_and_created_at", using: :btree
  add_index "communities", ["user_id"], name: "index_communities_on_user_id", using: :btree

  create_table "connections", force: :cascade do |t|
    t.integer  "fan_id"
    t.integer  "idol_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "covers", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "delayed_jobs", force: :cascade do |t|
    t.integer  "priority",   default: 0, null: false
    t.integer  "attempts",   default: 0, null: false
    t.text     "handler",                null: false
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.string   "queue"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "delayed_jobs", ["priority", "run_at"], name: "delayed_jobs_priority", using: :btree

  create_table "hearts", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "post_id"
    t.integer  "comment_id"
    t.integer  "reply_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "notifications", force: :cascade do |t|
    t.integer  "sender_id"
    t.integer  "receiver_id"
    t.string   "category"
    t.boolean  "unread"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.integer  "post_id"
    t.integer  "comment_id"
  end

  create_table "posts", force: :cascade do |t|
    t.string   "title"
    t.text     "description"
    t.integer  "user_id"
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.integer  "flags",          default: 0
    t.integer  "views",          default: 0
    t.integer  "community_id"
    t.string   "link"
    t.string   "linkphoto"
    t.string   "linktitle"
    t.string   "image"
    t.string   "slug"
    t.integer  "hearts_count",   default: 0
    t.integer  "comments_count", default: 0
    t.integer  "coin_count",     default: 0
  end

  add_index "posts", ["slug"], name: "index_posts_on_slug", unique: true, using: :btree
  add_index "posts", ["user_id", "created_at"], name: "index_posts_on_user_id_and_created_at", using: :btree
  add_index "posts", ["user_id"], name: "index_posts_on_user_id", using: :btree

  create_table "relationships", force: :cascade do |t|
    t.integer  "follower_id"
    t.integer  "favourite_id"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  add_index "relationships", ["follower_id", "favourite_id"], name: "index_relationships_on_follower_id_and_favourite_id", unique: true, using: :btree

  create_table "replies", force: :cascade do |t|
    t.text     "body"
    t.integer  "user_id"
    t.integer  "comment_id"
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
    t.integer  "hearts_count", default: 0
    t.integer  "parent_id"
  end

  add_index "replies", ["comment_id"], name: "index_replies_on_comment_id", using: :btree
  add_index "replies", ["user_id", "comment_id", "created_at"], name: "index_replies_on_user_id_and_comment_id_and_created_at", using: :btree
  add_index "replies", ["user_id"], name: "index_replies_on_user_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "username"
    t.string   "email"
    t.string   "password_digest"
    t.datetime "created_at",                                       null: false
    t.datetime "updated_at",                                       null: false
    t.string   "role"
    t.integer  "points",                 default: 0
    t.string   "level",                  default: "Fresh Gabblin"
    t.string   "password_reset_token"
    t.datetime "password_reset_sent_at"
    t.integer  "waitinglist_id"
    t.string   "oneliner"
    t.boolean  "banflag",                default: false
    t.boolean  "subscribeflag",          default: true
    t.string   "avatar"
    t.string   "slug"
    t.string   "activation_token"
    t.boolean  "activated",              default: false
    t.string   "unsubscribe_token"
    t.integer  "coin_count",             default: 30
  end

  add_index "users", ["slug"], name: "index_users_on_slug", unique: true, using: :btree

  add_foreign_key "comments", "posts"
  add_foreign_key "comments", "users"
  add_foreign_key "communities", "users"
  add_foreign_key "posts", "users"
  add_foreign_key "replies", "comments"
  add_foreign_key "replies", "users"
end
