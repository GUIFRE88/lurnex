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

ActiveRecord::Schema[8.1].define(version: 2026_04_16_095501) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "course_progresses", force: :cascade do |t|
    t.datetime "completed_at"
    t.datetime "created_at", null: false
    t.bigint "enrollment_id", null: false
    t.integer "percentage", default: 0, null: false
    t.datetime "updated_at", null: false
    t.index ["enrollment_id"], name: "index_course_progresses_on_enrollment_id"
  end

  create_table "courses", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.text "description"
    t.bigint "organization_id", null: false
    t.string "title", null: false
    t.datetime "updated_at", null: false
    t.index ["organization_id", "title"], name: "index_courses_on_organization_id_and_title"
    t.index ["organization_id"], name: "index_courses_on_organization_id"
  end

  create_table "enrollments", force: :cascade do |t|
    t.bigint "course_id", null: false
    t.datetime "created_at", null: false
    t.bigint "membership_id", null: false
    t.bigint "organization_id", null: false
    t.datetime "updated_at", null: false
    t.index ["course_id", "membership_id"], name: "index_enrollments_on_course_id_and_membership_id", unique: true
    t.index ["course_id"], name: "index_enrollments_on_course_id"
    t.index ["membership_id"], name: "index_enrollments_on_membership_id"
    t.index ["organization_id"], name: "index_enrollments_on_organization_id"
  end

  create_table "invites", force: :cascade do |t|
    t.datetime "accepted_at"
    t.datetime "created_at", null: false
    t.string "email_address", null: false
    t.bigint "invited_by_membership_id", null: false
    t.bigint "organization_id", null: false
    t.integer "role", default: 1, null: false
    t.string "token", null: false
    t.datetime "updated_at", null: false
    t.index ["invited_by_membership_id"], name: "index_invites_on_invited_by_membership_id"
    t.index ["organization_id", "email_address", "accepted_at"], name: "index_invites_org_email_accepted"
    t.index ["organization_id"], name: "index_invites_on_organization_id"
    t.index ["token"], name: "index_invites_on_token", unique: true
  end

  create_table "memberships", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "organization_id", null: false
    t.integer "role", default: 1, null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["organization_id"], name: "index_memberships_on_organization_id"
    t.index ["user_id", "organization_id"], name: "index_memberships_on_user_id_and_organization_id", unique: true
    t.index ["user_id"], name: "index_memberships_on_user_id"
  end

  create_table "organizations", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "name", null: false
    t.string "slug", null: false
    t.datetime "updated_at", null: false
    t.index ["slug"], name: "index_organizations_on_slug", unique: true
  end

  create_table "sessions", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "ip_address"
    t.datetime "updated_at", null: false
    t.string "user_agent"
    t.bigint "user_id", null: false
    t.index ["user_id"], name: "index_sessions_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "email_address", null: false
    t.string "password_digest", null: false
    t.datetime "updated_at", null: false
    t.index ["email_address"], name: "index_users_on_email_address", unique: true
  end

  add_foreign_key "course_progresses", "enrollments"
  add_foreign_key "courses", "organizations"
  add_foreign_key "enrollments", "courses"
  add_foreign_key "enrollments", "memberships"
  add_foreign_key "enrollments", "organizations"
  add_foreign_key "invites", "memberships", column: "invited_by_membership_id"
  add_foreign_key "invites", "organizations"
  add_foreign_key "memberships", "organizations"
  add_foreign_key "memberships", "users"
  add_foreign_key "sessions", "users"
end
