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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20111217052413) do

  create_table "active_admin_comments", :force => true do |t|
    t.integer  "resource_id",   :null => false
    t.string   "resource_type", :null => false
    t.integer  "author_id"
    t.string   "author_type"
    t.text     "body"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "namespace"
  end

  add_index "active_admin_comments", ["author_type", "author_id"], :name => "index_active_admin_comments_on_author_type_and_author_id"
  add_index "active_admin_comments", ["namespace"], :name => "index_active_admin_comments_on_namespace"
  add_index "active_admin_comments", ["resource_type", "resource_id"], :name => "index_admin_notes_on_resource_type_and_resource_id"

  create_table "admin_notes", :force => true do |t|
    t.integer  "resource_id",     :null => false
    t.string   "resource_type",   :null => false
    t.integer  "admin_user_id"
    t.string   "admin_user_type"
    t.text     "body"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "admin_users", :force => true do |t|
    t.string   "email",                                 :default => "", :null => false
    t.string   "encrypted_password",     :limit => 128, :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                         :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "admin_users", ["email"], :name => "index_admin_users_on_email", :unique => true
  add_index "admin_users", ["reset_password_token"], :name => "index_admin_users_on_reset_password_token", :unique => true

  create_table "budget_item_types", :force => true do |t|
    t.string   "name"
    t.string   "description"
    t.integer  "seq_number"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "budget_items", :force => true do |t|
    t.integer  "site_id"
    t.integer  "item_id"
    t.decimal  "amount"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "church_types", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name"
    t.integer  "denomination_id"
    t.integer  "conference_id"
    t.integer  "organization_id"
  end

  create_table "churches", :force => true do |t|
    t.string   "name"
    t.string   "city"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "liaison_id"
    t.string   "address2"
    t.string   "state"
    t.string   "zip"
    t.string   "office_phone"
    t.string   "fax"
    t.string   "email1"
    t.string   "address1"
    t.boolean  "active"
    t.boolean  "registered"
    t.integer  "church_type_id"
  end

  create_table "conferences", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "denominations", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "liaison_types", :force => true do |t|
    t.string   "name"
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "liaisons", :force => true do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "address1"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "church_id"
    t.string   "title"
    t.string   "address2"
    t.string   "city"
    t.string   "state"
    t.string   "zip"
    t.string   "home_phone"
    t.string   "cell_phone"
    t.string   "work_phone"
    t.string   "fax"
    t.string   "email1"
    t.string   "email2"
    t.string   "name"
    t.integer  "liaison_type_id"
  end

  create_table "organizations", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "other_parameters", :force => true do |t|
    t.date     "current_fiscal_year"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "payment_schedules", :force => true do |t|
    t.string   "name"
    t.decimal  "deposit"
    t.decimal  "second_payment"
    t.decimal  "total_payment"
    t.decimal  "final_payment"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.date     "second_payment_date"
    t.date     "final_payment_date"
  end

  create_table "payments", :force => true do |t|
    t.integer  "registration_id"
    t.date     "payment_date"
    t.decimal  "payment_amount"
    t.string   "payment_method"
    t.text     "payment_notes"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "scheduled_group_id"
  end

  create_table "periods", :force => true do |t|
    t.string   "name"
    t.datetime "start_date"
    t.datetime "end_date"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "active"
    t.boolean  "summer_domestic"
  end

  create_table "program_types", :force => true do |t|
    t.string   "name"
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "registrations", :force => true do |t|
    t.string   "name"
    t.integer  "liaison_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "request1"
    t.integer  "request2"
    t.integer  "request3"
    t.integer  "request4"
    t.integer  "request5"
    t.integer  "request6"
    t.integer  "request7"
    t.integer  "request8"
    t.integer  "request9"
    t.integer  "request10"
    t.integer  "requested_counselors"
    t.integer  "requested_youth"
    t.integer  "requested_total"
    t.boolean  "scheduled"
    t.text     "comments"
    t.decimal  "amount_due"
    t.decimal  "amount_paid"
    t.string   "payment_method"
    t.text     "payment_notes"
    t.integer  "group_type_id"
    t.integer  "church_id"
    t.string   "registration_step"
  end

  create_table "scheduled_groups", :force => true do |t|
    t.integer  "current_youth"
    t.integer  "current_counselors"
    t.integer  "current_total"
    t.integer  "session_id"
    t.integer  "church_id"
    t.integer  "history"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name"
    t.string   "comments"
    t.integer  "registration_id"
    t.integer  "scheduled_priority"
    t.integer  "liaison_id"
  end

  create_table "scheduled_histories", :force => true do |t|
    t.integer  "registration_id"
    t.date     "history_date"
    t.string   "action"
    t.string   "comments"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "scheduled_group_id"
  end

  create_table "session_types", :force => true do |t|
    t.string   "name"
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "sessions", :force => true do |t|
    t.string   "name"
    t.integer  "site_id"
    t.integer  "period_id"
    t.integer  "session_type_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "payment_schedule_id"
  end

  create_table "sites", :force => true do |t|
    t.string   "name"
    t.string   "address1"
    t.string   "address2"
    t.string   "city"
    t.string   "state"
    t.string   "zip"
    t.string   "phone"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "listing_priority"
    t.boolean  "active"
    t.boolean  "summer_domestic"
  end

end
