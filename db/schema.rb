# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.0].define(version: 2025_06_21_060000) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "achievements", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.text "content", null: false
    t.string "category", null: false
    t.integer "points", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["category"], name: "index_achievements_on_category"
    t.index ["user_id", "created_at"], name: "index_achievements_on_user_id_and_created_at"
    t.index ["user_id"], name: "index_achievements_on_user_id"
  end

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "avatar_transformations", force: :cascade do |t|
    t.bigint "mentor_avatar_id", null: false
    t.string "trigger_type", null: false
    t.integer "trigger_value", null: false
    t.datetime "transformation_date", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["mentor_avatar_id", "transformation_date"], name: "idx_on_mentor_avatar_id_transformation_date_71f6076be4"
    t.index ["mentor_avatar_id"], name: "index_avatar_transformations_on_mentor_avatar_id"
    t.index ["trigger_type"], name: "index_avatar_transformations_on_trigger_type"
  end

  create_table "development_times", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.datetime "start_time", null: false
    t.datetime "end_time"
    t.integer "duration"
    t.text "notes"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id", "start_time"], name: "index_development_times_on_user_id_and_start_time"
    t.index ["user_id"], name: "index_development_times_on_user_id"
  end

  create_table "level_up_settings", force: :cascade do |t|
    t.string "name", null: false
    t.text "description"
    t.integer "hours_per_level", default: 1, null: false
    t.integer "achievements_per_level", default: 0, null: false
    t.boolean "enabled", default: true, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["enabled"], name: "index_level_up_settings_on_enabled"
  end

  create_table "members", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_members_on_name", unique: true
  end

  create_table "mentor_avatars", force: :cascade do |t|
    t.string "name", null: false
    t.text "description", null: false
    t.integer "level", default: 1, null: false
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["level"], name: "index_mentor_avatars_on_level"
    t.index ["user_id"], name: "index_mentor_avatars_on_user_id"
  end

  create_table "nullpo_games", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "nullpo_count", default: 0, null: false
    t.bigint "total_clicks", default: 0, null: false
    t.bigint "auto_clicks_per_second", default: 0, null: false
    t.bigint "click_power", default: 1, null: false
    t.datetime "last_auto_click_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["auto_clicks_per_second"], name: "index_nullpo_games_on_auto_clicks_per_second"
    t.index ["nullpo_count"], name: "index_nullpo_games_on_nullpo_count"
    t.index ["user_id"], name: "index_nullpo_games_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name", null: false
    t.string "email", null: false
    t.integer "total_development_time", default: 0, null: false
    t.integer "level", default: 1, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
  end

  create_table "work_logs", force: :cascade do |t|
    t.bigint "member_id", null: false
    t.datetime "start_time", null: false
    t.datetime "end_time"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["member_id"], name: "index_work_logs_on_member_id"
  end

  add_foreign_key "achievements", "users"
  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "avatar_transformations", "mentor_avatars"
  add_foreign_key "development_times", "users"
  add_foreign_key "mentor_avatars", "users"
  add_foreign_key "nullpo_games", "users"
  add_foreign_key "work_logs", "members"
end
