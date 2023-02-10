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

ActiveRecord::Schema[7.0].define(version: 2023_02_10_043720) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_trgm"
  enable_extension "plpgsql"

  create_table "modder_photos", force: :cascade do |t|
    t.bigint "modder_id", null: false
    t.string "uuid", null: false
    t.string "photo", null: false
    t.integer "index", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "width"
    t.integer "height"
    t.index ["modder_id"], name: "index_modder_photos_on_modder_id"
  end

  create_table "modder_services", force: :cascade do |t|
    t.bigint "modder_id", null: false
    t.string "service", null: false
    t.integer "index", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["modder_id"], name: "index_modder_services_on_modder_id"
  end

  create_table "modders", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "name", null: false
    t.string "slug", null: false
    t.string "bio"
    t.string "twitter_username"
    t.string "etsy_shop"
    t.string "website_url"
    t.string "featured_link"
    t.string "status", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "city"
    t.string "latitude"
    t.string "longitude"
    t.string "logo"
    t.string "uuid"
    t.string "vetting_status"
    t.index ["name"], name: "index_modders_on_name", opclass: :gin_trgm_ops, using: :gin
    t.index ["slug"], name: "index_modders_on_slug", unique: true
    t.index ["user_id"], name: "index_modders_on_user_id"
    t.index ["vetting_status"], name: "index_modders_on_vetting_status"
  end

  create_table "user_invitations", force: :cascade do |t|
    t.bigint "invitee_user_id"
    t.string "claim_token"
    t.string "status", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "inviter_user_id"
    t.string "email"
    t.index ["claim_token"], name: "index_user_invitations_on_claim_token"
    t.index ["invitee_user_id"], name: "index_user_invitations_on_invitee_user_id"
    t.index ["inviter_user_id"], name: "index_user_invitations_on_inviter_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

end
