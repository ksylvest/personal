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

ActiveRecord::Schema.define(version: 2018_02_10_050633) do

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
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "attachings", force: :cascade do |t|
    t.bigint "attachment_id", null: false
    t.string "document_type", null: false
    t.bigint "document_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["attachment_id"], name: "index_attachings_on_attachment_id"
    t.index ["document_type", "document_id"], name: "index_attachings_on_document_type_and_document_id"
  end

  create_table "attachments", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "pages", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "status", null: false
    t.string "slug", null: false
    t.string "title", null: false
    t.text "summary", null: false
    t.text "body", null: false
    t.text "tags", default: [], null: false, array: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index "to_tsvector('english'::regconfig, (((((COALESCE(title, ''::character varying))::text || ' '::text) || COALESCE(summary, ''::text)) || ' '::text) || COALESCE(body, ''::text)))", name: "index_pages_on_tsvector", using: :gin
    t.index ["slug"], name: "index_pages_on_slug", unique: true
    t.index ["status"], name: "index_pages_on_status"
    t.index ["tags"], name: "index_pages_on_tags", using: :gin
    t.index ["user_id"], name: "index_pages_on_user_id"
  end

  create_table "posts", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "status", null: false
    t.string "segment", null: false
    t.string "slug", null: false
    t.string "title", null: false
    t.text "summary", null: false
    t.text "body", null: false
    t.text "tags", default: [], null: false, array: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index "to_tsvector('english'::regconfig, (((((COALESCE(title, ''::character varying))::text || ' '::text) || COALESCE(summary, ''::text)) || ' '::text) || COALESCE(body, ''::text)))", name: "index_posts_on_tsvector", using: :gin
    t.index ["segment", "slug"], name: "index_posts_on_segment_and_slug", unique: true
    t.index ["status"], name: "index_posts_on_status"
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

  add_foreign_key "attachings", "attachments"
  add_foreign_key "pages", "users"
  add_foreign_key "posts", "users"
end
