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

ActiveRecord::Schema.define(version: 2025_07_23_160926) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "pgcrypto"
  enable_extension "plpgsql"

  create_table "abitrary_photos", force: :cascade do |t|
    t.jsonb "abitrary_photo_data"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "authors", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "banking_orders", force: :cascade do |t|
    t.decimal "amount", precision: 10, scale: 2
    t.string "unique_code"
    t.text "message"
    t.string "name"
    t.string "email"
    t.datetime "valid_until"
    t.datetime "paid_at"
    t.bigint "user_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_banking_orders_on_user_id"
  end

  create_table "categories", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "category_mangas", force: :cascade do |t|
    t.bigint "category_id", null: false
    t.bigint "manga_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["category_id"], name: "index_category_mangas_on_category_id"
    t.index ["manga_id"], name: "index_category_mangas_on_manga_id"
  end

  create_table "chapters", force: :cascade do |t|
    t.string "number"
    t.string "name"
    t.bigint "translation_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "order"
    t.integer "pages_count", default: 0, null: false
    t.integer "views_count", default: 0, null: false
    t.datetime "discarded_at"
    t.integer "comments_count", default: 0, null: false
    t.integer "status", default: 0, null: false
    t.datetime "edited_at"
    t.float "progress", default: 0.0
    t.index ["discarded_at"], name: "index_chapters_on_discarded_at"
    t.index ["order"], name: "index_chapters_on_order"
    t.index ["translation_id"], name: "index_chapters_on_translation_id"
  end

  create_table "comment_replies", force: :cascade do |t|
    t.bigint "replied_id", null: false
    t.bigint "reply_id", null: false
    t.index ["replied_id", "reply_id"], name: "index_comment_replies_on_replied_id_and_reply_id", unique: true
    t.index ["replied_id"], name: "index_comment_replies_on_replied_id"
    t.index ["reply_id"], name: "index_comment_replies_on_reply_id"
  end

  create_table "comments", force: :cascade do |t|
    t.text "content"
    t.bigint "user_id", null: false
    t.bigint "page_id"
    t.bigint "parent_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "chapter_id"
    t.bigint "translation_id"
    t.text "processed_content"
    t.datetime "removed_at"
    t.bigint "remover_id"
    t.text "remove_reason"
    t.boolean "is_shadow_removed", default: false, null: false
    t.string "commentable_type", default: "Chapter", null: false
    t.bigint "commentable_id", default: 0, null: false
    t.index ["chapter_id"], name: "index_comments_on_chapter_id"
    t.index ["commentable_type", "commentable_id"], name: "index_comments_on_commentable_type_and_commentable_id"
    t.index ["created_at"], name: "index_comments_on_created_at"
    t.index ["page_id"], name: "index_comments_on_page_id"
    t.index ["parent_id"], name: "index_comments_on_parent_id"
    t.index ["remover_id"], name: "index_comments_on_remover_id"
    t.index ["translation_id"], name: "index_comments_on_translation_id"
    t.index ["user_id"], name: "index_comments_on_user_id"
  end

  create_table "donations", force: :cascade do |t|
    t.decimal "amount", precision: 10, scale: 2
    t.string "unique_code"
    t.text "message"
    t.string "name"
    t.string "email"
    t.string "sepay_id"
    t.string "sepay_reference_code"
    t.bigint "user_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_donations_on_user_id"
  end

  create_table "good_jobs", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.text "queue_name"
    t.integer "priority"
    t.jsonb "serialized_params"
    t.datetime "scheduled_at"
    t.datetime "performed_at"
    t.datetime "finished_at"
    t.text "error"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.uuid "active_job_id"
    t.text "concurrency_key"
    t.text "cron_key"
    t.uuid "retried_good_job_id"
    t.datetime "cron_at"
    t.index ["active_job_id", "created_at"], name: "index_good_jobs_on_active_job_id_and_created_at"
    t.index ["concurrency_key"], name: "index_good_jobs_on_concurrency_key_when_unfinished", where: "(finished_at IS NULL)"
    t.index ["cron_key", "created_at"], name: "index_good_jobs_on_cron_key_and_created_at"
    t.index ["cron_key", "cron_at"], name: "index_good_jobs_on_cron_key_and_cron_at", unique: true
    t.index ["queue_name", "scheduled_at"], name: "index_good_jobs_on_queue_name_and_scheduled_at", where: "(finished_at IS NULL)"
    t.index ["scheduled_at"], name: "index_good_jobs_on_scheduled_at", where: "(finished_at IS NULL)"
  end

  create_table "manga_logs", force: :cascade do |t|
    t.bigint "manga_id", null: false
    t.integer "views_count"
    t.date "date"
    t.index ["manga_id", "date"], name: "index_manga_logs_on_manga_id_and_date", unique: true
    t.index ["manga_id"], name: "index_manga_logs_on_manga_id"
  end

  create_table "mangas", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.bigint "author_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.text "cover_data"
    t.text "panorama_data"
    t.integer "focus_x"
    t.integer "focus_y"
    t.datetime "discarded_at"
    t.boolean "marginless", default: false
    t.integer "status"
    t.integer "views_count", default: 0, null: false
    t.string "official_url"
    t.bigint "newest_chapter_id"
    t.bigint "primary_title_id"
    t.integer "views_count_week", default: 0, null: false
    t.integer "views_count_month", default: 0, null: false
    t.boolean "is_region_limited", default: false
    t.datetime "edited_at"
    t.integer "direction", default: 0
    t.decimal "trending_score", precision: 15, scale: 10, default: "0.0"
    t.text "full_description"
    t.index ["author_id"], name: "index_mangas_on_author_id"
    t.index ["discarded_at"], name: "index_mangas_on_discarded_at"
    t.index ["newest_chapter_id"], name: "index_mangas_on_newest_chapter_id"
    t.index ["primary_title_id"], name: "index_mangas_on_primary_title_id"
    t.index ["trending_score"], name: "index_mangas_on_trending_score"
  end

  create_table "mangas_tags", force: :cascade do |t|
    t.bigint "manga_id", null: false
    t.bigint "tag_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["manga_id"], name: "index_mangas_tags_on_manga_id"
    t.index ["tag_id"], name: "index_mangas_tags_on_tag_id"
  end

  create_table "notifications", force: :cascade do |t|
    t.string "recipient_type", null: false
    t.bigint "recipient_id", null: false
    t.string "type", null: false
    t.jsonb "params"
    t.datetime "read_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["read_at"], name: "index_notifications_on_read_at"
    t.index ["recipient_type", "recipient_id"], name: "index_notifications_on_recipient"
  end

  create_table "pages", force: :cascade do |t|
    t.bigint "chapter_id", null: false
    t.integer "order"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.text "image_data"
    t.text "drm_data"
    t.integer "status", default: 0, null: false
    t.text "drm_data_raw"
    t.index ["chapter_id"], name: "index_pages_on_chapter_id"
    t.index ["order"], name: "index_pages_on_order"
  end

  create_table "tags", force: :cascade do |t|
    t.string "name"
    t.string "description"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "slug"
    t.integer "tagging_count", default: 0, null: false
    t.integer "category", default: 0
  end

  create_table "team_logs", force: :cascade do |t|
    t.bigint "team_id", null: false
    t.integer "views_count", default: 0, null: false
    t.date "date"
    t.index ["team_id", "date"], name: "index_team_logs_on_team_id_and_date", unique: true
    t.index ["team_id"], name: "index_team_logs_on_team_id"
  end

  create_table "team_members", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "team_id", null: false
    t.integer "role"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["team_id"], name: "index_team_members_on_team_id"
    t.index ["user_id"], name: "index_team_members_on_user_id"
  end

  create_table "team_posts", force: :cascade do |t|
    t.bigint "team_id", null: false
    t.text "content"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["team_id"], name: "index_team_posts_on_team_id"
  end

  create_table "teams", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "views_count", default: 0, null: false
    t.integer "translations_count", default: 0, null: false
    t.string "facebook_address"
    t.boolean "is_ads", default: true
    t.integer "views_count_week", default: 0, null: false
    t.integer "views_count_month", default: 0, null: false
    t.string "slug"
    t.json "main_page_blocks"
    t.jsonb "avatar_data"
    t.index ["slug"], name: "index_teams_on_slug", unique: true
  end

  create_table "titles", force: :cascade do |t|
    t.string "name"
    t.boolean "primary"
    t.bigint "manga_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["manga_id"], name: "index_titles_on_manga_id"
  end

  create_table "translation_logs", force: :cascade do |t|
    t.bigint "translation_id", null: false
    t.integer "views_count", default: 0, null: false
    t.date "date"
    t.index ["translation_id", "date"], name: "index_translation_logs_on_translation_id_and_date", unique: true
    t.index ["translation_id"], name: "index_translation_logs_on_translation_id"
  end

  create_table "translations", force: :cascade do |t|
    t.string "language"
    t.bigint "manga_id", null: false
    t.bigint "team_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "chapters_count", default: 0, null: false
    t.datetime "discarded_at"
    t.integer "views_count", default: 0, null: false
    t.index ["discarded_at"], name: "index_translations_on_discarded_at"
    t.index ["manga_id"], name: "index_translations_on_manga_id"
    t.index ["team_id"], name: "index_translations_on_team_id"
  end

  create_table "user_bans", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.integer "ban_type"
    t.string "reason"
    t.datetime "banned_until"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_user_bans_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "username"
    t.string "email"
    t.string "password_digest"
    t.integer "level", default: 0, null: false
    t.string "auth_token"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.datetime "auth_token_valid_until"
    t.string "reset_password_token"
    t.datetime "reset_password_token_valid_until"
    t.integer "cuucoin", default: 0
    t.index ["auth_token"], name: "index_users_on_auth_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["username"], name: "index_users_on_username", unique: true
  end

  create_table "users_follow_mangas", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "manga_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["manga_id"], name: "index_users_follow_mangas_on_manga_id"
    t.index ["user_id"], name: "index_users_follow_mangas_on_user_id"
  end

  create_table "web_push_endpoints", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.text "endpoint_url"
    t.text "auth"
    t.text "p256dh"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id", "endpoint_url"], name: "index_web_push_endpoints_on_user_id_and_endpoint_url", unique: true
    t.index ["user_id"], name: "index_web_push_endpoints_on_user_id"
  end

  add_foreign_key "banking_orders", "users"
  add_foreign_key "category_mangas", "categories"
  add_foreign_key "category_mangas", "mangas"
  add_foreign_key "chapters", "translations"
  add_foreign_key "comment_replies", "comments", column: "replied_id"
  add_foreign_key "comment_replies", "comments", column: "reply_id"
  add_foreign_key "comments", "chapters"
  add_foreign_key "comments", "comments", column: "parent_id"
  add_foreign_key "comments", "pages"
  add_foreign_key "comments", "translations"
  add_foreign_key "comments", "users"
  add_foreign_key "comments", "users", column: "remover_id"
  add_foreign_key "donations", "users"
  add_foreign_key "manga_logs", "mangas"
  add_foreign_key "mangas", "authors"
  add_foreign_key "mangas", "chapters", column: "newest_chapter_id"
  add_foreign_key "mangas", "titles", column: "primary_title_id"
  add_foreign_key "mangas_tags", "mangas"
  add_foreign_key "mangas_tags", "tags"
  add_foreign_key "pages", "chapters"
  add_foreign_key "team_logs", "teams"
  add_foreign_key "team_members", "teams"
  add_foreign_key "team_members", "users"
  add_foreign_key "team_posts", "teams"
  add_foreign_key "titles", "mangas"
  add_foreign_key "translation_logs", "translations"
  add_foreign_key "translations", "mangas"
  add_foreign_key "translations", "teams"
  add_foreign_key "user_bans", "users"
  add_foreign_key "users_follow_mangas", "mangas"
  add_foreign_key "users_follow_mangas", "users"
  add_foreign_key "web_push_endpoints", "users"
end
