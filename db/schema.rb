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

ActiveRecord::Schema.define(version: 20180630181247) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "addresses", force: :cascade do |t|
    t.boolean "shipping"
    t.string "street"
    t.string "city"
    t.string "state"
    t.integer "zipcode"
    t.string "name"
    t.string "apt"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_order_id"
    t.index ["user_order_id"], name: "index_addresses_on_user_order_id"
  end

  create_table "bid_offers", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "bid_id"
    t.date "delivery_date"
    t.integer "price"
    t.string "notes"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["bid_id"], name: "index_bid_offers_on_bid_id"
    t.index ["user_id"], name: "index_bid_offers_on_user_id"
  end

  create_table "bids", force: :cascade do |t|
    t.integer "amount"
    t.string "title"
    t.integer "price_max"
    t.bigint "supplier_id"
    t.bigint "buyer_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "final_price"
    t.boolean "paid"
    t.string "product_type"
    t.date "early_date"
    t.date "late_date"
    t.string "frequency"
    t.boolean "DEH_approved"
    t.boolean "published"
    t.index ["buyer_id"], name: "index_bids_on_buyer_id"
    t.index ["supplier_id"], name: "index_bids_on_supplier_id"
  end

  create_table "bulk_orders", force: :cascade do |t|
    t.integer "percent_filled"
    t.integer "expiration"
    t.string "item"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "max_amount"
    t.datetime "expire_date"
    t.boolean "completed"
    t.bigint "item_id"
    t.integer "market_price"
    t.integer "wholesale_price"
    t.string "item_name"
    t.string "description"
    t.boolean "published"
    t.integer "buyer_count"
    t.index ["item_id"], name: "index_bulk_orders_on_item_id"
  end

  create_table "bulk_orders_users", id: false, force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "bulk_order_id", null: false
    t.index ["bulk_order_id", "user_id"], name: "index_bulk_orders_users_on_bulk_order_id_and_user_id"
    t.index ["user_id", "bulk_order_id"], name: "index_bulk_orders_users_on_user_id_and_bulk_order_id"
  end

  create_table "emails", force: :cascade do |t|
    t.string "email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "items", force: :cascade do |t|
    t.string "item_name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id"
    t.integer "current_amount"
    t.string "avatar_file_name"
    t.string "avatar_content_type"
    t.integer "avatar_file_size"
    t.datetime "avatar_updated_at"
    t.string "description"
    t.integer "rating"
    t.integer "rating_count"
    t.index ["user_id"], name: "index_items_on_user_id"
  end

  create_table "order_items", force: :cascade do |t|
    t.string "name"
    t.integer "price"
    t.integer "max_amount"
    t.integer "bulk_order_amount"
    t.integer "current_amount"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "avatar_file_name"
    t.string "avatar_content_type"
    t.integer "avatar_file_size"
    t.datetime "avatar_updated_at"
    t.bigint "user_id"
    t.boolean "closed"
    t.bigint "item_id"
    t.integer "market_price"
    t.index ["item_id"], name: "index_order_items_on_item_id"
    t.index ["user_id"], name: "index_order_items_on_user_id"
  end

  create_table "reviews", force: :cascade do |t|
    t.integer "rating"
    t.string "body"
    t.bigint "user_id"
    t.bigint "item_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "title"
    t.bigint "bulk_order_id"
    t.bigint "user_order_id"
    t.index ["bulk_order_id"], name: "index_reviews_on_bulk_order_id"
    t.index ["item_id"], name: "index_reviews_on_item_id"
    t.index ["user_id"], name: "index_reviews_on_user_id"
    t.index ["user_order_id"], name: "index_reviews_on_user_order_id"
  end

  create_table "user_orders", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "bulk_order_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "quantity"
    t.integer "expiration"
    t.integer "total_price"
    t.string "charge_token"
    t.boolean "buy_now"
    t.string "tracking_number"
    t.string "tracking_label"
    t.index ["bulk_order_id"], name: "index_user_orders_on_bulk_order_id"
    t.index ["user_id"], name: "index_user_orders_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "company_name"
    t.string "email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "password_digest"
    t.boolean "is_vendor"
    t.integer "zipcode"
    t.string "city"
    t.string "state"
    t.string "supplier_code"
    t.string "avatar_file_name"
    t.string "avatar_content_type"
    t.integer "avatar_file_size"
    t.datetime "avatar_updated_at"
    t.boolean "email_confirmed", default: false
    t.string "email_confirm_token"
  end

  add_foreign_key "addresses", "user_orders"
  add_foreign_key "bid_offers", "bids"
  add_foreign_key "bid_offers", "users"
  add_foreign_key "bulk_orders", "items"
  add_foreign_key "items", "users"
  add_foreign_key "order_items", "items"
  add_foreign_key "order_items", "users"
  add_foreign_key "reviews", "bulk_orders"
  add_foreign_key "reviews", "items"
  add_foreign_key "reviews", "user_orders"
  add_foreign_key "reviews", "users"
  add_foreign_key "user_orders", "bulk_orders"
  add_foreign_key "user_orders", "users"
end
