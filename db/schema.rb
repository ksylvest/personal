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

ActiveRecord::Schema[7.1].define(version: 2020_12_09_203441) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "hstore"
  enable_extension "pg_trgm"
  enable_extension "plpgsql"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.bigint "byte_size", null: false
    t.string "checksum", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "service_name", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "attachings", id: :serial, force: :cascade do |t|
    t.integer "attachment_id", null: false
    t.integer "document_id", null: false
    t.string "document_type", limit: 255, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["attachment_id"], name: "index_attachings_on_attachment_id"
    t.index ["document_id", "document_type"], name: "index_attachings_on_document_id_and_document_type"
  end

  create_table "attachments", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "pages", id: :serial, force: :cascade do |t|
    t.integer "user_id", null: false
    t.string "status", limit: 255, null: false
    t.string "slug", limit: 255, null: false
    t.string "title", limit: 255, null: false
    t.text "summary", null: false
    t.text "body", null: false
    t.text "tags", default: [], null: false, array: true
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index "to_tsvector('english'::regconfig, (((((COALESCE(title, ''::character varying))::text || ' '::text) || COALESCE(summary, ''::text)) || ' '::text) || COALESCE(body, ''::text)))", name: "index_pages_on_tsvector", using: :gin
    t.index ["slug"], name: "index_pages_on_slug", unique: true
    t.index ["tags"], name: "index_pages_on_tags", using: :gin
    t.index ["user_id"], name: "index_pages_on_user_id"
  end

  create_table "posts", id: :serial, force: :cascade do |t|
    t.integer "user_id", null: false
    t.string "status", limit: 255, null: false
    t.string "segment", limit: 255, null: false
    t.string "slug", limit: 255, null: false
    t.string "title", limit: 255, null: false
    t.text "summary", null: false
    t.text "body", null: false
    t.text "tags", default: [], null: false, array: true
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index "to_tsvector('english'::regconfig, (((((COALESCE(title, ''::character varying))::text || ' '::text) || COALESCE(summary, ''::text)) || ' '::text) || COALESCE(body, ''::text)))", name: "index_posts_on_tsvector", using: :gin
    t.index ["slug"], name: "index_posts_on_slug", unique: true
    t.index ["tags"], name: "index_posts_on_tags", using: :gin
    t.index ["user_id"], name: "index_posts_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "role", null: false
    t.string "name", null: false
    t.string "email", null: false
    t.string "password_digest", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
  end

  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "attachings", "attachments"
  add_foreign_key "pages", "users"
  add_foreign_key "posts", "users"
end
