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

ActiveRecord::Schema.define(:version => 20120127202620) do

  create_table "admin_users", :force => true do |t|
    t.string   "email"
    t.string   "password_salt"
    t.string   "password_hash"
    t.string   "first_name"
    t.string   "last_name"
    t.integer  "role"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "affiliate_links", :force => true do |t|
    t.integer  "affiliate_id"
    t.string   "url_token"
    t.string   "subid_param_name"
    t.float    "signup_payout",    :default => 0.0
    t.string   "pingback_url"
    t.integer  "experiment_id"
    t.text     "trigger_html"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "affiliates", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "email_from_lines", :force => true do |t|
    t.string   "name"
    t.string   "email_type"
    t.boolean  "active",     :default => true
    t.string   "from"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "email_subjects", :force => true do |t|
    t.string   "name"
    t.string   "email_type"
    t.boolean  "active",     :default => true
    t.string   "subject"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "email_templates", :force => true do |t|
    t.string   "name"
    t.string   "email_type"
    t.boolean  "active",     :default => true
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "experiments", :force => true do |t|
    t.string   "conversion_event"
    t.string   "name"
    t.string   "delivery_url"
    t.string   "traffic_group"
    t.boolean  "active",           :default => false
    t.datetime "activation_date"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "invite_from_lines", :force => true do |t|
    t.string   "name"
    t.boolean  "active",     :default => true
    t.boolean  "reminder",   :default => false
    t.string   "from"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "invite_subjects", :force => true do |t|
    t.string   "name"
    t.boolean  "active",     :default => true
    t.boolean  "reminder",   :default => false
    t.string   "subject"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "invite_templates", :force => true do |t|
    t.string   "name"
    t.boolean  "active",     :default => true
    t.boolean  "reminder",   :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "path_element_groups", :force => true do |t|
    t.integer  "experiment_id"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "path_elements", :force => true do |t|
    t.integer  "path_spot_id"
    t.integer  "path_element_group_id"
    t.string   "name"
    t.boolean  "active",                :default => true
    t.text     "html"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "path_flows", :force => true do |t|
    t.integer  "experiment_id"
    t.string   "flow"
    t.boolean  "active",        :default => true
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "path_pages", :force => true do |t|
    t.string   "page_type"
    t.string   "name"
    t.integer  "experiment_id"
    t.boolean  "active",        :default => true
    t.string   "layout"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "path_spots", :force => true do |t|
    t.string   "name"
    t.integer  "path_page_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "security_codes", :force => true do |t|
    t.string   "code"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "email"
    t.string   "phone"
    t.string   "password_salt"
    t.string   "password_hash"
    t.string   "fb_user_id"
    t.date     "birthday"
    t.integer  "referrer_id"
    t.string   "referral_token"
    t.string   "country"
    t.string   "city"
    t.string   "zip"
    t.text     "about_me"
    t.string   "gender"
    t.integer  "affiliate_link_id"
    t.string   "affiliate_subid"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "variant_combinations", :force => true do |t|
    t.integer  "experiment_id"
    t.integer  "path_flow_id"
    t.string   "key"
    t.boolean  "active",        :default => true
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
