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

ActiveRecord::Schema.define(:version => 20100422172623) do

  create_table "baselines", :force => true do |t|
    t.integer  "user_id"
    t.integer  "duration"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.float    "work_green"
    t.float    "work_alone"
    t.float    "school_green"
    t.float    "school_alone"
    t.float    "kids_green"
    t.float    "kids_alone"
    t.float    "errands_green"
    t.float    "errands_alone"
    t.float    "faith_green"
    t.float    "faith_alone"
    t.float    "social_green"
    t.float    "social_alone"
    t.float    "total_miles"
    t.float    "green_miles"
  end

  add_index "baselines", ["user_id"], :name => "index_baselines_on_user_id", :unique => true

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
    t.boolean  "green"
  end

  create_table "friendships", :force => true do |t|
    t.integer  "user_id",    :null => false
    t.integer  "friend_id",  :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "friendships", ["friend_id"], :name => "index_friendships_on_friend_id"
  add_index "friendships", ["user_id", "friend_id"], :name => "index_friendships_on_user_id_and_friend_id", :unique => true

  create_table "groups", :force => true do |t|
    t.string   "name",           :null => false
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "destination_id", :null => false
    t.integer  "owner_id",       :null => false
  end

  add_index "groups", ["destination_id"], :name => "index_groups_on_destination_id"
  add_index "groups", ["owner_id"], :name => "index_groups_on_owner_id"

  create_table "invitations", :force => true do |t|
    t.string   "email",      :null => false
    t.integer  "user_id",    :null => false
    t.text     "invitation", :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name",       :null => false
  end

  add_index "invitations", ["user_id"], :name => "index_invitations_on_user_id"

  create_table "lengths", :force => true do |t|
    t.integer  "trip_id"
    t.integer  "mode_id"
    t.integer  "distance"
    t.integer  "unit_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "lengths", ["mode_id"], :name => "index_lengths_on_mode_id"
  add_index "lengths", ["trip_id"], :name => "index_lengths_on_trip_id"
  add_index "lengths", ["unit_id"], :name => "index_lengths_on_unit_id"

  create_table "memberships", :force => true do |t|
    t.integer  "user_id",    :null => false
    t.integer  "group_id",   :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "memberships", ["group_id"], :name => "index_memberships_on_group_id"
  add_index "memberships", ["user_id", "group_id"], :name => "index_memberships_on_user_id_and_group_id", :unique => true

  create_table "messages", :force => true do |t|
    t.boolean  "receiver_deleted"
    t.boolean  "receiver_purged"
    t.boolean  "sender_deleted"
    t.boolean  "sender_purged"
    t.datetime "read_at"
    t.integer  "receiver_id"
    t.integer  "sender_id"
    t.string   "subject",          :null => false
    t.text     "body"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "messages", ["receiver_id"], :name => "index_messages_on_receiver_id"
  add_index "messages", ["sender_id"], :name => "index_messages_on_sender_id"

  create_table "modes", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "green"
    t.float    "lb_co2_per_mile"
    t.string   "description"
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
    t.float    "distance"
    t.integer  "unit_id"
    t.date     "made_at"
  end

  add_index "trips", ["destination_id"], :name => "index_trips_on_destination_id"
  add_index "trips", ["mode_id"], :name => "index_trips_on_mode_id"
  add_index "trips", ["unit_id"], :name => "index_trips_on_unit_id"
  add_index "trips", ["user_id"], :name => "index_trips_on_user_id"

  create_table "units", :force => true do |t|
    t.string   "name"
    t.integer  "in_miles"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.string   "email"
    t.string   "crypted_password"
    t.string   "password_salt"
    t.string   "persistence_token"
    t.string   "single_access_token"
    t.string   "perishable_token"
    t.integer  "login_count",                       :default => 0,     :null => false
    t.integer  "failed_login_count",                :default => 0,     :null => false
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
    t.boolean  "admin",                             :default => false
    t.string   "city"
    t.integer  "green_miles",                       :default => 0
    t.integer  "facebook_uid",         :limit => 8
    t.string   "facebook_session_key"
    t.string   "name",                              :default => ""
    t.string   "address",                           :default => ""
    t.boolean  "is_13"
    t.boolean  "is_parent"
    t.boolean  "read_privacy"
    t.string   "zip"
  end

  add_index "users", ["community_id"], :name => "index_users_on_community_id"

end
