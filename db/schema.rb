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

ActiveRecord::Schema.define(version: 20170118114158) do

  create_table "authors", force: :cascade do |t|
    t.string "full_name"
    t.string "last_name"
    t.string "first_name"
    t.string "seo"
  end

  add_index "authors", ["full_name"], name: "index_authors_on_full_name"
  add_index "authors", ["last_name"], name: "index_authors_on_last_name"
  add_index "authors", ["seo"], name: "index_authors_on_seo", unique: true

  create_table "authors_books", force: :cascade do |t|
    t.integer "author_id", null: false
    t.integer "book_id",   null: false
  end

  add_index "authors_books", ["author_id", "book_id"], name: "index_authors_books_on_author_id_and_book_id", unique: true

  create_table "books", force: :cascade do |t|
    t.string  "title"
    t.text    "description"
    t.string  "cover"
    t.string  "domain"
    t.string  "source"
    t.string  "paper"
    t.string  "txt"
    t.string  "rtf"
    t.string  "doc"
    t.string  "pdf"
    t.string  "fb2"
    t.string  "ebup"
    t.string  "mobi"
    t.string  "djvu"
    t.integer "genre_id"
    t.string  "seo"
  end

  add_index "books", ["domain"], name: "index_books_on_domain"
  add_index "books", ["genre_id"], name: "index_books_on_genre_id"
  add_index "books", ["seo"], name: "index_books_on_seo", unique: true
  add_index "books", ["source"], name: "index_books_on_source"
  add_index "books", ["title"], name: "index_books_on_title"

  create_table "books_tags", force: :cascade do |t|
    t.integer "tag_id",  null: false
    t.integer "book_id", null: false
  end

  add_index "books_tags", ["tag_id", "book_id"], name: "index_books_tags_on_tag_id_and_book_id", unique: true

  create_table "genres", force: :cascade do |t|
    t.string "title"
    t.string "seo"
  end

  add_index "genres", ["seo"], name: "index_genres_on_seo", unique: true

  create_table "tags", force: :cascade do |t|
    t.string "title"
    t.string "seo"
  end

  add_index "tags", ["seo"], name: "index_tags_on_seo", unique: true

end
