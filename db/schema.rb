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

ActiveRecord::Schema.define(version: 20140801204332) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "comments", force: true do |t|
    t.text     "content"
    t.integer  "commentable_id"
    t.string   "commentable_type"
    t.string   "username"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "comments", ["commentable_id", "commentable_type", "username"], name: "my_index", using: :btree

  create_table "my_recipes", force: true do |t|
    t.string   "title"
    t.text     "description"
    t.string   "speechlink"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
    t.string   "photo"
    t.text     "servings"
    t.text     "time"
    t.text     "calories"
    t.text     "fat"
    t.text     "saturated"
    t.text     "poly"
    t.text     "mono"
    t.text     "carb"
    t.text     "protein"
    t.text     "sodium"
    t.text     "fiber"
    t.text     "cholesterol"
  end

  create_table "ratings", force: true do |t|
    t.integer  "site_recipe_id"
    t.integer  "my_recipe_id"
    t.integer  "user_id"
    t.integer  "score"
    t.string   "default"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "ratings", ["my_recipe_id"], name: "index_ratings_on_my_recipe_id", using: :btree
  add_index "ratings", ["site_recipe_id"], name: "index_ratings_on_site_recipe_id", using: :btree
  add_index "ratings", ["user_id"], name: "index_ratings_on_user_id", using: :btree

  create_table "site_recipes", force: true do |t|
    t.text     "title"
    t.text     "ingredients"
    t.text     "preparation"
    t.text     "image"
    t.text     "source"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "servings"
    t.text     "time"
    t.text     "calories"
    t.text     "fat"
    t.text     "saturated"
    t.text     "poly"
    t.text     "mono"
    t.text     "carb"
    t.text     "protein"
    t.text     "sodium"
    t.text     "fiber"
    t.text     "cholesterol"
  end

  create_table "users", force: true do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "username"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  add_index "users", ["username"], name: "index_users_on_username", unique: true, using: :btree

end
