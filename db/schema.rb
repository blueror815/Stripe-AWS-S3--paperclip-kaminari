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

ActiveRecord::Schema.define(version: 20151129060557) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "api_keys", force: true do |t|
    t.string   "access_token"
    t.datetime "expires_at"
    t.integer  "user_id"
    t.boolean  "active"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  add_index "api_keys", ["access_token"], name: "index_api_keys_on_access_token", unique: true, using: :btree
  add_index "api_keys", ["user_id"], name: "index_api_keys_on_user_id", using: :btree

  create_table "cart_items", force: true do |t|
    t.integer  "quantity_in_cart"
    t.integer  "item_id"
    t.integer  "sale_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "cart_items", ["item_id"], name: "index_cart_items_on_item_id", using: :btree
  add_index "cart_items", ["sale_id"], name: "index_cart_items_on_sale_id", using: :btree

  create_table "categories", force: true do |t|
    t.string   "name"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.boolean  "deleted_state",       default: false
    t.integer  "ordering_identifier"
    t.integer  "item_id"
  end

  create_table "customers", force: true do |t|
    t.integer  "zip"
    t.string   "state"
    t.string   "phone"
    t.string   "last_name"
    t.string   "first_name"
    t.string   "email"
    t.string   "city"
    t.string   "address"
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
    t.boolean  "deleted_state", default: false
  end

  create_table "items", force: true do |t|
    t.string   "sku"
    t.integer  "quantity_sold"
    t.integer  "quantity_on_hand"
    t.decimal  "price",              precision: 8, scale: 2
    t.string   "order_link"
    t.string   "nickname"
    t.text     "item_description"
    t.string   "full_name"
    t.datetime "created_at",                                                 null: false
    t.datetime "updated_at",                                                 null: false
    t.integer  "user_id"
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.boolean  "deleted_state",                              default: false
    t.integer  "quantity_on_road"
    t.boolean  "is_road_merch"
    t.string   "sync_uuid"
    t.decimal  "unit_cost",          precision: 8, scale: 2
  end

  add_index "items", ["sync_uuid"], name: "index_items_on_sync_uuid", using: :btree

  create_table "promo_codes", force: true do |t|
    t.string   "code"
    t.text     "description"
    t.integer  "duration"
    t.datetime "expiration"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
  end

  add_index "promo_codes", ["code"], name: "index_promo_codes_on_code", using: :btree

  create_table "sales", force: true do |t|
    t.decimal  "tax",           precision: 8, scale: 2
    t.decimal  "discount",      precision: 8, scale: 2
    t.datetime "date"
    t.decimal  "amount",        precision: 8, scale: 2
    t.datetime "created_at",                                            null: false
    t.datetime "updated_at",                                            null: false
    t.boolean  "deleted_state",                         default: false
    t.string   "sale_type"
    t.string   "invoice_id"
    t.string   "sync_uuid"
    t.integer  "user_id"
    t.integer  "show_id"
  end

  create_table "shows", force: true do |t|
    t.datetime "date"
    t.boolean  "active"
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
    t.integer  "user_id"
    t.integer  "venue_id"
    t.boolean  "deleted_state",   default: false
    t.boolean  "road_merch_only"
    t.string   "sync_uuid"
    t.integer  "venue_cut"
  end

  add_index "shows", ["sync_uuid"], name: "index_shows_on_sync_uuid", using: :btree

  create_table "subscriptions", force: true do |t|
    t.integer  "user_id"
    t.string   "stripe_customer_id"
    t.string   "stripe_subscription_id"
    t.decimal  "amount"
    t.date     "date"
    t.date     "cancelled_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: true do |t|
    t.string   "username"
    t.string   "password_digest"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "status"
    t.text     "description"
    t.string   "phone"
    t.string   "email"
    t.text     "misc"
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.datetime "trial_began"
    t.datetime "trial_ended"
    t.string   "artist_name"
    t.integer  "promo_code_id"
    t.string   "stripe_customer_id"
    t.string   "stripe_subscription_id"
    t.date     "stripe_active_until"
    t.integer  "subscription_id"
  end

  create_table "venues", force: true do |t|
    t.integer  "zip"
    t.decimal  "variable_fee",   precision: 8, scale: 2
    t.string   "state"
    t.string   "phone"
    t.string   "name"
    t.decimal  "management_fee", precision: 8, scale: 2
    t.decimal  "fixed_fee",      precision: 8, scale: 2
    t.string   "email"
    t.string   "city"
    t.string   "address"
    t.datetime "created_at",                                             null: false
    t.datetime "updated_at",                                             null: false
    t.integer  "show_id"
    t.boolean  "deleted_state",                          default: false
    t.string   "contact"
  end

end
