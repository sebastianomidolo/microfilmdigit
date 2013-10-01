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
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20131001083829) do

  create_table "articles", force: true do |t|
    t.integer  "issue_id",               null: false
    t.string   "title",      limit: 240, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "created_by"
    t.integer  "updated_by"
    t.integer  "position"
  end

  add_index "articles", ["title"], name: "index_articles_on_title", using: :btree

  create_table "issues", force: true do |t|
    t.integer  "journal_id",                null: false
    t.string   "annata",         limit: 20
    t.string   "fascicolo",      limit: 38
    t.string   "extra_info",     limit: 6
    t.integer  "anno"
    t.string   "info_fascicolo", limit: 32
    t.string   "bobina",         limit: 9
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "created_by"
    t.integer  "updated_by"
    t.integer  "position"
  end

  add_index "issues", ["annata"], name: "index_issues_on_annata", using: :btree
  add_index "issues", ["anno"], name: "index_issues_on_anno", using: :btree
  add_index "issues", ["bobina"], name: "index_issues_on_bobina", using: :btree
  add_index "issues", ["extra_info"], name: "index_issues_on_extra_info", using: :btree
  add_index "issues", ["fascicolo"], name: "index_issues_on_fascicolo", using: :btree
  add_index "issues", ["info_fascicolo"], name: "index_issues_on_info_fascicolo", using: :btree

  create_table "journals", force: true do |t|
    t.string   "title",                   limit: 120,                 null: false
    t.string   "bid",                     limit: 12
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "created_by"
    t.integer  "updated_by"
    t.string   "keytit",                  limit: 120
    t.boolean  "pubblicato",                          default: false, null: false
    t.integer  "clavis_manifestation_id"
  end

  add_index "journals", ["bid", "title"], name: "index_journals_on_bid_and_title", unique: true, using: :btree
  add_index "journals", ["bid"], name: "index_journals_on_bid", using: :btree
  add_index "journals", ["title"], name: "index_journals_on_title", using: :btree

  create_table "pages", force: true do |t|
    t.integer  "article_id",            null: false
    t.string   "imagepath",  limit: 29
    t.string   "pagenumber", limit: 20
    t.string   "sequential", limit: 5
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "created_by"
    t.integer  "updated_by"
    t.integer  "position"
  end

  add_index "pages", ["article_id"], name: "index_pages_on_article_id", using: :btree

  create_table "standardvolumesheet", force: true do |t|
    t.string "imagepath",        limit: 29,  null: false
    t.string "datapath",         limit: 29,  null: false
    t.string "paper",            limit: 85,  null: false
    t.string "papertopic",       limit: 1
    t.string "bibliographic_id", limit: 11
    t.string "year_issue",       limit: 20
    t.string "release",          limit: 38
    t.string "edition",          limit: 6
    t.string "date",             limit: 1
    t.string "year",             limit: 4
    t.string "datename",         limit: 27
    t.string "pagenumber",       limit: 20
    t.string "pagetopic",        limit: 1
    t.string "rubrica",          limit: 1
    t.string "article",          limit: 100
    t.string "articletopic",     limit: 1
    t.string "author",           limit: 1
    t.string "code",             limit: 9
    t.string "column",           limit: 1
    t.string "scrutiny",         limit: 1
    t.string "sequential",       limit: 5
  end

  add_index "standardvolumesheet", ["article"], name: "article_idx", using: :btree
  add_index "standardvolumesheet", ["bibliographic_id"], name: "bibliographic_id_idx", using: :btree
  add_index "standardvolumesheet", ["datename"], name: "datename_idx", using: :btree
  add_index "standardvolumesheet", ["edition"], name: "edition_idx", using: :btree
  add_index "standardvolumesheet", ["paper"], name: "paper_idx", using: :btree
  add_index "standardvolumesheet", ["release"], name: "release_idx", using: :btree
  add_index "standardvolumesheet", ["year"], name: "year_idx", using: :btree
  add_index "standardvolumesheet", ["year_issue"], name: "year_issue_idx", using: :btree

  create_table "users", force: true do |t|
    t.string   "login"
    t.string   "email"
    t.string   "crypted_password",          limit: 40
    t.string   "salt",                      limit: 40
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "remember_token"
    t.datetime "remember_token_expires_at"
  end

  create_table "versions", force: true do |t|
    t.string   "item_type",  null: false
    t.integer  "item_id",    null: false
    t.string   "event",      null: false
    t.string   "whodunnit"
    t.text     "object"
    t.datetime "created_at"
  end

  add_index "versions", ["item_type", "item_id"], name: "index_versions_on_item_type_and_item_id", using: :btree

end
