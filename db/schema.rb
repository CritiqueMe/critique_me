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

ActiveRecord::Schema.define(:version => 20120618200413) do

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
    t.float    "conversion_payout", :default => 0.0
    t.string   "pingback_url"
    t.integer  "experiment_id"
    t.text     "trigger_html"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "trigger_event"
  end

  create_table "affiliates", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "answers", :force => true do |t|
    t.integer  "user_id"
    t.integer  "question_id"
    t.integer  "multiple_choice_option_id"
    t.boolean  "true_false_answer"
    t.text     "open_text_answer"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "fb_answer_id"
    t.integer  "canned_question_choice_id"
  end

  create_table "canned_question_choices", :force => true do |t|
    t.integer "question_id"
    t.string  "friend_name"
    t.string  "friend_fb_id"
  end

  create_table "canned_questions", :force => true do |t|
    t.text    "text"
    t.integer "num_choices"
    t.integer "category_id"
    t.boolean "active",      :default => true
  end

  create_table "categories", :force => true do |t|
    t.string  "name"
    t.boolean "active", :default => true
  end

  create_table "default_multiple_choice_options", :force => true do |t|
    t.integer "default_question_id"
    t.boolean "active",              :default => true
    t.text    "answer_text"
  end

  create_table "default_questions", :force => true do |t|
    t.integer  "category_id"
    t.integer  "questionnaire_id"
    t.integer  "question_type",    :default => 0
    t.boolean  "active",           :default => true
    t.text     "question_text"
    t.datetime "last_asked_at"
    t.integer  "priority",         :default => 0
    t.boolean  "featured",         :default => false
  end

  create_table "delayed_jobs", :force => true do |t|
    t.integer  "priority",   :default => 0
    t.integer  "attempts",   :default => 0
    t.text     "handler"
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.string   "queue"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "delayed_jobs", ["priority", "run_at"], :name => "delayed_jobs_priority"

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

  create_table "fb_share_templates", :force => true do |t|
    t.string   "name"
    t.text     "message"
    t.string   "link_display"
    t.string   "caption"
    t.text     "description"
    t.boolean  "active",        :default => true
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "share_type",    :default => "news-post"
    t.string   "question_type"
  end

  create_table "flagged_questions", :force => true do |t|
    t.integer  "question_id"
    t.integer  "user_id"
    t.string   "flag_reason"
    t.text     "message"
    t.boolean  "hidden",      :default => false
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

  create_table "karma_levels", :force => true do |t|
    t.integer  "level_num"
    t.string   "action"
    t.integer  "events_needed_per_day"
    t.integer  "days_needed"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "levels", :force => true do |t|
    t.integer  "level_num"
    t.integer  "xp_requirement"
    t.string   "bonuses"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "login_history", :force => true do |t|
    t.integer  "user_id",          :null => false
    t.date     "login_date",       :null => false
    t.string   "login_year_month", :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "multiple_choice_options", :force => true do |t|
    t.integer  "question_id"
    t.text     "answer_text"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "default_multiple_choice_option_id"
  end

  create_table "order_history", :force => true do |t|
    t.integer  "user_id",                          :null => false
    t.integer  "order_package",                    :null => false
    t.integer  "fb_credit_amount",  :default => 0, :null => false
    t.integer  "our_credit_amount", :default => 0, :null => false
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

  create_table "questionnaires", :force => true do |t|
    t.string  "name"
    t.boolean "active", :default => true
  end

  create_table "questions", :force => true do |t|
    t.integer  "user_id"
    t.integer  "question_type"
    t.integer  "default_question_id"
    t.integer  "category_id"
    t.text     "question_text"
    t.string   "photo"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "fb_question_id"
    t.integer  "canned_question_id"
    t.boolean  "active",              :default => true
    t.boolean  "public",              :default => false
  end

  create_table "security_codes", :force => true do |t|
    t.string   "code"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "user_upgrades", :force => true do |t|
    t.string   "kind",       :null => false
    t.integer  "amount",     :null => false
    t.string   "bonuses"
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
    t.integer  "privacy_ask_questions", :default => 0
    t.integer  "xp",                    :default => 0
    t.integer  "level_id"
    t.integer  "karma_level_id"
    t.integer  "current_energy"
    t.integer  "energy_bucket_size"
    t.integer  "rank_score",            :default => 0
    t.datetime "friends_updated_at"
    t.text     "fb_pic_square"
    t.datetime "last_login"
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
