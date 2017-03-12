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

ActiveRecord::Schema.define(version: 20170102234958) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "comments", force: :cascade do |t|
    t.text     "comment"
    t.integer  "commentable_id"
    t.string   "commentable_type"
    t.string   "name"
    t.string   "email"
    t.string   "website"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
  end

  create_table "coupon_kohls_categories", force: :cascade do |t|
    t.integer  "coupon_id",         null: false
    t.integer  "kohls_category_id", null: false
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
  end

  add_index "coupon_kohls_categories", ["coupon_id"], name: "index_coupon_kohls_categories_on_coupon_id", using: :btree
  add_index "coupon_kohls_categories", ["kohls_category_id"], name: "index_coupon_kohls_categories_on_kohls_category_id", using: :btree

  create_table "coupon_kohls_onlies", force: :cascade do |t|
    t.integer  "coupon_id",     null: false
    t.integer  "kohls_only_id", null: false
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  add_index "coupon_kohls_onlies", ["coupon_id"], name: "index_coupon_kohls_onlies_on_coupon_id", using: :btree
  add_index "coupon_kohls_onlies", ["kohls_only_id"], name: "index_coupon_kohls_onlies_on_kohls_only_id", using: :btree

  create_table "coupon_kohls_types", force: :cascade do |t|
    t.integer  "coupon_id",     null: false
    t.integer  "kohls_type_id", null: false
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  add_index "coupon_kohls_types", ["coupon_id"], name: "index_coupon_kohls_types_on_coupon_id", using: :btree
  add_index "coupon_kohls_types", ["kohls_type_id"], name: "index_coupon_kohls_types_on_kohls_type_id", using: :btree

  create_table "coupons", force: :cascade do |t|
    t.string   "id_of_coupon"
    t.text     "title"
    t.text     "description"
    t.datetime "start_date"
    t.datetime "end_date"
    t.string   "code"
    t.text     "restriction"
    t.text     "link"
    t.text     "impression_pixel"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
    t.string   "slug"
    t.string   "image"
    t.string   "tagline"
  end

  create_table "friendly_id_slugs", force: :cascade do |t|
    t.string   "slug",                      null: false
    t.integer  "sluggable_id",              null: false
    t.string   "sluggable_type", limit: 50
    t.string   "scope"
    t.datetime "created_at"
  end

  add_index "friendly_id_slugs", ["slug", "sluggable_type", "scope"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type_and_scope", unique: true, using: :btree
  add_index "friendly_id_slugs", ["slug", "sluggable_type"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type", using: :btree
  add_index "friendly_id_slugs", ["sluggable_id"], name: "index_friendly_id_slugs_on_sluggable_id", using: :btree
  add_index "friendly_id_slugs", ["sluggable_type"], name: "index_friendly_id_slugs_on_sluggable_type", using: :btree

  create_table "kohls_categories", force: :cascade do |t|
    t.string   "name"
    t.integer  "kc_id"
    t.string   "slug"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "kohls_categories", ["slug"], name: "index_kohls_categories_on_slug", using: :btree

  create_table "kohls_onlies", force: :cascade do |t|
    t.string   "name"
    t.integer  "kc_id"
    t.string   "slug"
    t.string   "image"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "kohls_types", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "name"
    t.string   "slug"
    t.integer  "kc_id"
  end

  create_table "removed_coupons", force: :cascade do |t|
    t.integer  "id_of_coupon"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "",    null: false
    t.string   "encrypted_password",     default: "",    null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
    t.string   "name"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.string   "invitation_token"
    t.datetime "invitation_created_at"
    t.datetime "invitation_sent_at"
    t.datetime "invitation_accepted_at"
    t.integer  "invitation_limit"
    t.integer  "invited_by_id"
    t.string   "invited_by_type"
    t.integer  "invitations_count",      default: 0
    t.boolean  "admin",                  default: false
    t.string   "slug"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["invitation_token"], name: "index_users_on_invitation_token", unique: true, using: :btree
  add_index "users", ["invitations_count"], name: "index_users_on_invitations_count", using: :btree
  add_index "users", ["invited_by_id"], name: "index_users_on_invited_by_id", using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

end
