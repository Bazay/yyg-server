# encoding: UTF-8
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

ActiveRecord::Schema.define(:version => 20141128142911) do

  create_table "accounts", :force => true do |t|
    t.string   "email"
    t.string   "registered_to"
    t.boolean  "deleted",       :default => false
    t.datetime "deleted_at"
    t.datetime "created_at",                       :null => false
    t.datetime "updated_at",                       :null => false
  end

  add_index "accounts", ["email"], :name => "index_accounts_on_email"

  create_table "licences", :force => true do |t|
    t.integer  "account_id"
    t.integer  "product_id"
    t.integer  "sub_product_id"
    t.string   "key"
    t.datetime "expires_at"
    t.datetime "expired_at"
    t.datetime "activated_at"
    t.datetime "revoked_at"
    t.string   "licence_state"
    t.string   "type"
    t.boolean  "deleted",        :default => false
    t.datetime "deleted_at"
    t.datetime "created_at",                        :null => false
    t.datetime "updated_at",                        :null => false
  end

  add_index "licences", ["account_id"], :name => "index_licences_on_account_id"
  add_index "licences", ["key"], :name => "index_licences_on_key"
  add_index "licences", ["product_id"], :name => "index_licences_on_product_id"
  add_index "licences", ["sub_product_id"], :name => "index_licences_on_sub_product_id"

  create_table "products", :force => true do |t|
    t.string   "name"
    t.string   "product_type"
    t.float    "base_price"
    t.boolean  "deleted",      :default => false
    t.datetime "deleted_at"
    t.datetime "created_at",                      :null => false
    t.datetime "updated_at",                      :null => false
  end

  create_table "products_sub_products", :id => false, :force => true do |t|
    t.integer "product_id"
    t.integer "sub_product_id"
  end

  create_table "sub_products", :force => true do |t|
    t.string   "name"
    t.string   "sub_product_type"
    t.float    "base_price"
    t.boolean  "deleted",          :default => false
    t.datetime "deleted_at"
    t.datetime "created_at",                          :null => false
    t.datetime "updated_at",                          :null => false
  end

end
