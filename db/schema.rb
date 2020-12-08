# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2020_12_08_050252) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_admin_comments", force: :cascade do |t|
    t.string "namespace"
    t.text "body"
    t.string "resource_type"
    t.bigint "resource_id"
    t.string "author_type"
    t.bigint "author_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["author_type", "author_id"], name: "index_active_admin_comments_on_author_type_and_author_id"
    t.index ["namespace"], name: "index_active_admin_comments_on_namespace"
    t.index ["resource_type", "resource_id"], name: "index_active_admin_comments_on_resource_type_and_resource_id"
  end

  create_table "admin_users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["email"], name: "index_admin_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_admin_users_on_reset_password_token", unique: true
  end

  create_table "admin_users_roles", id: false, force: :cascade do |t|
    t.bigint "admin_user_id"
    t.bigint "role_id"
    t.index ["admin_user_id", "role_id"], name: "index_admin_users_roles_on_admin_user_id_and_role_id"
    t.index ["admin_user_id"], name: "index_admin_users_roles_on_admin_user_id"
    t.index ["role_id"], name: "index_admin_users_roles_on_role_id"
  end

  create_table "categories", force: :cascade do |t|
    t.string "title"
    t.string "description"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "comments", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "item_id", null: false
    t.text "body"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["item_id"], name: "index_comments_on_item_id"
    t.index ["user_id"], name: "index_comments_on_user_id"
  end

  create_table "diet_sub_items", force: :cascade do |t|
    t.bigint "diet_id"
    t.bigint "sub_item_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["diet_id"], name: "index_diet_sub_items_on_diet_id"
    t.index ["sub_item_id"], name: "index_diet_sub_items_on_sub_item_id"
  end

  create_table "diets", force: :cascade do |t|
    t.integer "start_calorie"
    t.integer "end_calorie"
    t.integer "purpose"
    t.text "body"
    t.boolean "snack"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "protein", default: 0
  end

  create_table "food_sub_items", force: :cascade do |t|
    t.bigint "food_id"
    t.bigint "sub_item_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["food_id"], name: "index_food_sub_items_on_food_id"
    t.index ["sub_item_id"], name: "index_food_sub_items_on_sub_item_id"
  end

  create_table "foods", force: :cascade do |t|
    t.string "title"
    t.text "body"
    t.string "image"
    t.float "kcal"
    t.integer "food_type", default: 0
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.float "carbo"
    t.float "protein"
    t.float "fat"
    t.integer "price"
  end

  create_table "gyms", force: :cascade do |t|
    t.string "title"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "gyms_sub_items", force: :cascade do |t|
    t.integer "gym_id"
    t.integer "sub_item_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "quantity", default: 0
    t.integer "order_quantity", default: 0
  end

  create_table "identities", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "uid"
    t.string "provider"
    t.string "access_token"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_identities_on_user_id"
  end

  create_table "items", force: :cascade do |t|
    t.string "title"
    t.integer "price"
    t.string "image"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "image2"
    t.integer "count"
    t.integer "point", default: 0
  end

  create_table "order_sub_items", force: :cascade do |t|
    t.bigint "order_id"
    t.bigint "sub_item_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "quantity"
    t.index ["order_id"], name: "index_order_sub_items_on_order_id"
    t.index ["sub_item_id"], name: "index_order_sub_items_on_sub_item_id"
  end

  create_table "orders", force: :cascade do |t|
    t.bigint "user_id"
    t.integer "number"
    t.integer "total"
    t.string "address1"
    t.string "address2"
    t.string "zipcode"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "payment_method"
    t.string "order_name"
    t.string "order_phone"
    t.string "order_email"
    t.string "deliver_name"
    t.string "deliver_phone"
    t.string "bank"
    t.string "bank_owner"
    t.string "bank_account"
    t.string "requirement"
    t.bigint "gym_id"
    t.bigint "item_id"
    t.integer "before_point", default: 0
    t.bigint "point_id"
    t.integer "status", default: 0
    t.datetime "paid_at"
    t.integer "payment_amount"
    t.string "tid"
    t.string "order_number"
    t.bigint "trainer_id"
    t.integer "order_type", default: 0
    t.index ["gym_id"], name: "index_orders_on_gym_id"
    t.index ["item_id"], name: "index_orders_on_item_id"
    t.index ["point_id"], name: "index_orders_on_point_id"
    t.index ["trainer_id"], name: "index_orders_on_trainer_id"
    t.index ["user_id"], name: "index_orders_on_user_id"
  end

  create_table "phone_certifications", force: :cascade do |t|
    t.string "phone"
    t.string "code"
    t.integer "count", default: 0
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "points", force: :cascade do |t|
    t.integer "amount"
    t.integer "point_type"
    t.bigint "user_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "sub_item_id"
    t.integer "remain_point"
    t.bigint "gym_id"
    t.index ["gym_id"], name: "index_points_on_gym_id"
    t.index ["sub_item_id"], name: "index_points_on_sub_item_id"
    t.index ["user_id"], name: "index_points_on_user_id"
  end

  create_table "posts", force: :cascade do |t|
    t.integer "age"
    t.float "height"
    t.float "weight"
    t.integer "gender"
    t.integer "activity"
    t.integer "work_time"
    t.integer "work_count"
    t.float "target_weight"
    t.string "target_date"
    t.integer "lunch"
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "work_strength"
    t.string "sickness"
    t.integer "post_type"
    t.string "phone"
    t.string "email"
    t.integer "period"
    t.integer "money"
    t.integer "is_morebox"
    t.integer "payment", default: 0
    t.integer "counsel_time"
  end

  create_table "purchases", force: :cascade do |t|
    t.bigint "gym_id"
    t.bigint "sub_item_id"
    t.integer "quantity", default: 0
    t.integer "status", default: 0
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["gym_id"], name: "index_purchases_on_gym_id"
    t.index ["sub_item_id"], name: "index_purchases_on_sub_item_id"
  end

  create_table "reports", force: :cascade do |t|
    t.string "name"
    t.decimal "weight"
    t.decimal "target_weight"
    t.string "target_date"
    t.float "morning_carbo"
    t.float "morning_protein"
    t.float "morning_fat"
    t.float "morning_kcal"
    t.float "lunch_carbo"
    t.float "lunch_protein"
    t.float "lunch_fat"
    t.float "lunch_kcal"
    t.float "dinner_carbo"
    t.float "dinner_protein"
    t.float "dinner_fat"
    t.float "dinner_kcal"
    t.float "snack_carbo"
    t.float "snack_protein"
    t.float "snack_fat"
    t.float "snack_kcal"
    t.float "ideal_kcal"
    t.float "ideal_carbo"
    t.float "ideal_protein"
    t.float "ideal_fat"
    t.string "comment"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "report_type", default: 0
    t.string "report_date"
  end

  create_table "roles", force: :cascade do |t|
    t.string "name"
    t.string "resource_type"
    t.bigint "resource_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["name", "resource_type", "resource_id"], name: "index_roles_on_name_and_resource_type_and_resource_id"
    t.index ["resource_type", "resource_id"], name: "index_roles_on_resource_type_and_resource_id"
  end

  create_table "sub_items", force: :cascade do |t|
    t.string "title"
    t.string "image"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "point", default: 0
    t.bigint "category_id"
    t.text "description"
    t.float "calorie"
    t.float "carbo"
    t.float "protein"
    t.float "fat"
    t.string "link"
    t.bigint "food_id"
    t.integer "sub_item_type", default: 0
    t.integer "price"
    t.integer "is_purchase", default: 0
    t.integer "min_quantity"
    t.integer "order_batch"
    t.index ["category_id"], name: "index_sub_items_on_category_id"
    t.index ["food_id"], name: "index_sub_items_on_food_id"
  end

  create_table "taggings", id: :serial, force: :cascade do |t|
    t.integer "tag_id"
    t.string "taggable_type"
    t.integer "taggable_id"
    t.string "tagger_type"
    t.integer "tagger_id"
    t.string "context", limit: 128
    t.datetime "created_at"
    t.index ["context"], name: "index_taggings_on_context"
    t.index ["tag_id", "taggable_id", "taggable_type", "context", "tagger_id", "tagger_type"], name: "taggings_idx", unique: true
    t.index ["tag_id"], name: "index_taggings_on_tag_id"
    t.index ["taggable_id", "taggable_type", "context"], name: "taggings_taggable_context_idx"
    t.index ["taggable_id", "taggable_type", "tagger_id", "context"], name: "taggings_idy"
    t.index ["taggable_id"], name: "index_taggings_on_taggable_id"
    t.index ["taggable_type"], name: "index_taggings_on_taggable_type"
    t.index ["tagger_id", "tagger_type"], name: "index_taggings_on_tagger_id_and_tagger_type"
    t.index ["tagger_id"], name: "index_taggings_on_tagger_id"
  end

  create_table "tags", id: :serial, force: :cascade do |t|
    t.string "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "taggings_count", default: 0
    t.index ["name"], name: "index_tags_on_name", unique: true
  end

  create_table "users", force: :cascade do |t|
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "phone"
    t.string "username"
    t.boolean "fit_center"
    t.string "email", default: "", null: false
    t.bigint "gym_id", null: false
    t.integer "gender"
    t.boolean "privacy", default: true
    t.string "referrer"
    t.boolean "marketing", default: true
    t.integer "user_type", default: 0
    t.index ["gym_id"], name: "index_users_on_gym_id"
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "comments", "items"
  add_foreign_key "comments", "users"
  add_foreign_key "diet_sub_items", "diets"
  add_foreign_key "diet_sub_items", "sub_items"
  add_foreign_key "food_sub_items", "foods"
  add_foreign_key "food_sub_items", "sub_items"
  add_foreign_key "identities", "users"
  add_foreign_key "order_sub_items", "orders"
  add_foreign_key "order_sub_items", "sub_items"
  add_foreign_key "orders", "gyms"
  add_foreign_key "orders", "items"
  add_foreign_key "orders", "points"
  add_foreign_key "orders", "users"
  add_foreign_key "orders", "users", column: "trainer_id"
  add_foreign_key "points", "gyms"
  add_foreign_key "points", "sub_items"
  add_foreign_key "points", "users"
  add_foreign_key "purchases", "gyms"
  add_foreign_key "purchases", "sub_items"
  add_foreign_key "sub_items", "categories"
  add_foreign_key "sub_items", "foods"
  add_foreign_key "taggings", "tags"
  add_foreign_key "users", "gyms"
end
