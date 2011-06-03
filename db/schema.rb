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

ActiveRecord::Schema.define(:version => 20110526124344) do

  create_table "admins", :force => true do |t|
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

  add_index "admins", ["email"], :name => "index_admins_on_email", :unique => true
  add_index "admins", ["reset_password_token"], :name => "index_admins_on_reset_password_token", :unique => true

  create_table "consultants", :force => true do |t|
    t.string  "first_name"
    t.string  "last_name"
    t.integer "service_level_id"
    t.string  "username"
  end

  create_table "devex_users", :force => true do |t|
    t.string   "username"
    t.integer  "account_id"
    t.string   "account_type"
    t.string   "first_name"
    t.string   "last_name"
    t.integer  "qb_id"
    t.string   "qb_member_name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "paypal_accounts", :force => true do |t|
    t.string   "email"
    t.string   "first_name"
    t.string   "last_name"
    t.integer  "devex_user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "payer_id"
  end

  create_table "products", :force => true do |t|
    t.string   "paypal_product_code"
    t.integer  "devex_product_id"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "service_level_id"
  end

  create_table "service_levels", :force => true do |t|
    t.integer  "devex_service_level_id"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "transactions", :force => true do |t|
    t.string   "status"
    t.string   "transaction_reference"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "transaction_date"
    t.text     "ipn_data"
    t.integer  "paypal_account_id"
    t.string   "transaction_type"
    t.float    "amount"
  end

end
