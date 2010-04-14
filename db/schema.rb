# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20100414154422) do

  create_table "baselines", :force => true do |t|
    t.integer  "user_id"
    t.integer  "duration"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "work_green"
    t.integer  "work_alone"
    t.integer  "school_green"
    t.integer  "school_alone"
    t.integer  "kids_green"
    t.integer  "kids_alone"
    t.integer  "errands_green"
    t.integer  "errands_alone"
    t.integer  "faith_green"
    t.integer  "faith_alone"
    t.integer  "social_green"
    t.integer  "social_alone"
    t.integer  "total_miles"
    t.integer  "green_miles"
  end

  create_table "communities", :force => true do |t|
    t.string   "name",        :null => false
    t.string   "state",       :null => false
    t.string   "country",     :null => false
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "destinations", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "groups", :force => true do |t|
    t.string   "name",           :null => false
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "owner_id",       :null => false
    t.integer  "destination_id", :null => false
  end

  create_table "lengths", :force => true do |t|
    t.integer  "trip_id"
    t.integer  "mode_id"
    t.integer  "distance"
    t.integer  "unit_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "memberships", :force => true do |t|
    t.integer  "user_id",    :null => false
    t.integer  "group_id",   :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "memberships", ["user_id", "group_id"], :name => "index_memberships_on_user_id_and_group_id", :unique => true

  create_table "modes", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "open_id_authentication_associations", :force => true do |t|
    t.integer "issued"
    t.integer "lifetime"
    t.string  "handle"
    t.string  "assoc_type"
    t.binary  "server_url"
    t.binary  "secret"
  end

  create_table "open_id_authentication_nonces", :force => true do |t|
    t.integer "timestamp",  :null => false
    t.string  "server_url"
    t.string  "salt",       :null => false
  end

  create_table "trips", :force => true do |t|
    t.integer  "user_id"
    t.integer  "destination_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "mode_id"
    t.integer  "distance"
    t.integer  "unit_id"
    t.date     "made_at"
  end

  create_table "units", :force => true do |t|
    t.string   "name"
    t.integer  "in_miles"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.string   "email",                                  :null => false
    t.string   "crypted_password",                       :null => false
    t.string   "password_salt",                          :null => false
    t.string   "persistence_token",                      :null => false
    t.string   "single_access_token",                    :null => false
    t.string   "perishable_token",                       :null => false
    t.integer  "login_count",         :default => 0,     :null => false
    t.integer  "failed_login_count",  :default => 0,     :null => false
    t.datetime "last_request_at"
    t.datetime "current_login_at"
    t.datetime "last_login_at"
    t.string   "current_login_ip"
    t.string   "last_login_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "openid_identifier"
    t.string   "username"
    t.string   "pseudonym"
    t.integer  "community_id"
    t.boolean  "admin",               :default => false
    t.string   "city"
  end

end
