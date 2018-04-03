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

ActiveRecord::Schema.define(version: 20180403201915) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

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
    t.index ["item_id"], name: "index_bulk_orders_on_item_id"
  end

  create_table "bulk_orders_users", id: false, force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "bulk_order_id", null: false
    t.index ["bulk_order_id", "user_id"], name: "index_bulk_orders_users_on_bulk_order_id_and_user_id"
    t.index ["user_id", "bulk_order_id"], name: "index_bulk_orders_users_on_user_id_and_bulk_order_id"
  end

  create_table "items", force: :cascade do |t|
    t.string "item_name"
    t.integer "price"
    t.string "image"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id"
    t.string "s"
    t.integer "max_amount"
    t.integer "bulk_order_amount"
    t.integer "current_amount"
    t.index ["user_id"], name: "index_items_on_user_id"
  end

  create_table "user_orders", force: :cascade do |t|
    t.string "item"
    t.bigint "user_id"
    t.bigint "bulk_order_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "quantity"
    t.integer "expiration"
    t.integer "total_price"
    t.string "charge_token"
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
  end

  add_foreign_key "bulk_orders", "items"
  add_foreign_key "items", "users"
  add_foreign_key "user_orders", "bulk_orders"
  add_foreign_key "user_orders", "users"
end
