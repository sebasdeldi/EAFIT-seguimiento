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

ActiveRecord::Schema.define(version: 20170505211707) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "general_questions", force: :cascade do |t|
    t.string   "class_assistance"
    t.string   "class_participation"
    t.string   "class_orders_following"
    t.integer  "numeric_calification"
    t.integer  "subject_id"
    t.integer  "student_id"
    t.integer  "teacher_id"
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.index ["subject_id"], name: "index_general_questions_on_subject_id", using: :btree
  end

  create_table "memberships", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "subject_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["subject_id"], name: "index_memberships_on_subject_id", using: :btree
    t.index ["user_id"], name: "index_memberships_on_user_id", using: :btree
  end

  create_table "programming_fundamentals_questions", force: :cascade do |t|
    t.integer  "numeric_calification"
    t.integer  "subject_id"
    t.integer  "student_id"
    t.integer  "teacher_id"
    t.string   "black_box"
    t.string   "pseudocode"
    t.string   "diagrams"
    t.string   "modularity"
    t.string   "sequences"
    t.string   "desitions"
    t.string   "loops"
    t.string   "functions"
    t.string   "data_structures"
    t.string   "abstraction"
    t.string   "encapsulation"
    t.string   "inheritance"
    t.string   "polymorphism"
    t.string   "class_diagrams"
    t.string   "implementation"
    t.string   "testing"
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
    t.index ["subject_id"], name: "index_programming_fundamentals_questions_on_subject_id", using: :btree
  end

  create_table "subjects", force: :cascade do |t|
    t.string   "name"
    t.string   "code"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "sw_dev_principles_questions", force: :cascade do |t|
    t.integer  "numeric_calification"
    t.integer  "subject_id"
    t.integer  "student_id"
    t.integer  "teacher_id"
    t.string   "arguments_presentation"
    t.string   "diagram_structure"
    t.string   "objective_presentation"
    t.string   "problem_solution"
    t.string   "case_use_diagrams"
    t.string   "class_diagrams"
    t.string   "secuence_diagrams"
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.index ["subject_id"], name: "index_sw_dev_principles_questions_on_subject_id", using: :btree
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.string   "names"
    t.string   "last_names"
    t.string   "highschool"
    t.string   "highschool_type"
    t.string   "technical_education"
    t.string   "origin_municipality"
    t.string   "address"
    t.string   "living_municipality"
    t.string   "living_neighbourhood"
    t.string   "scolarship"
    t.string   "computer_access"
    t.string   "code"
    t.string   "role"
    t.index ["email"], name: "index_users_on_email", unique: true, using: :btree
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  end

  add_foreign_key "general_questions", "subjects"
  add_foreign_key "memberships", "subjects"
  add_foreign_key "memberships", "users"
  add_foreign_key "programming_fundamentals_questions", "subjects"
  add_foreign_key "sw_dev_principles_questions", "subjects"
end
