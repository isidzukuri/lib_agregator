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

ActiveRecord::Schema.define(version: 2018_04_22_062232) do

  create_table "articles", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "title"
    t.text "description"
    t.text "text"
    t.string "cover"
    t.string "seo"
    t.integer "user_id"
    t.string "status", default: "published"
    t.index ["seo"], name: "index_articles_on_seo", unique: true
    t.index ["status"], name: "index_articles_on_status"
    t.index ["title"], name: "index_articles_on_title"
  end

  create_table "authors", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "full_name"
    t.string "last_name"
    t.string "first_name"
    t.string "seo"
    t.string "uk"
    t.boolean "hide"
    t.index ["full_name"], name: "index_authors_on_full_name"
    t.index ["last_name"], name: "index_authors_on_last_name"
    t.index ["seo"], name: "index_authors_on_seo", unique: true
  end

  create_table "authors_books", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "author_id", null: false
    t.integer "book_id", null: false
    t.index ["author_id"], name: "index_authors_books_on_author_id"
    t.index ["book_id"], name: "index_authors_books_on_book_id"
  end

  create_table "books", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "title"
    t.text "description"
    t.string "cover"
    t.string "domain"
    t.string "source"
    t.string "paper", limit: 500
    t.string "txt"
    t.string "rtf"
    t.string "doc"
    t.string "pdf"
    t.string "fb2"
    t.string "epub"
    t.string "mobi"
    t.string "djvu"
    t.integer "genre_id"
    t.string "seo"
    t.string "language"
    t.string "optimized_cover"
    t.boolean "hide"
    t.boolean "is_copy", default: false, null: false
    t.index ["djvu"], name: "index_books_on_djvu"
    t.index ["doc"], name: "index_books_on_doc"
    t.index ["domain"], name: "index_books_on_domain"
    t.index ["epub"], name: "index_books_on_epub"
    t.index ["fb2"], name: "index_books_on_fb2"
    t.index ["genre_id"], name: "index_books_on_genre_id"
    t.index ["is_copy"], name: "index_books_on_is_copy"
    t.index ["language"], name: "index_books_on_language"
    t.index ["mobi"], name: "index_books_on_mobi"
    t.index ["paper"], name: "index_books_on_paper"
    t.index ["pdf"], name: "index_books_on_pdf"
    t.index ["rtf"], name: "index_books_on_rtf"
    t.index ["seo"], name: "index_books_on_seo", unique: true
    t.index ["source"], name: "index_books_on_source"
    t.index ["title"], name: "index_books_on_title"
    t.index ["txt"], name: "index_books_on_txt"
  end

  create_table "books_lists", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "list_id", null: false
    t.integer "book_id", null: false
    t.index ["book_id"], name: "index_books_lists_on_book_id"
    t.index ["list_id", "book_id"], name: "index_books_lists_on_list_id_and_book_id", unique: true
    t.index ["list_id"], name: "index_books_lists_on_list_id"
  end

  create_table "books_tags", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "tag_id", null: false
    t.integer "book_id", null: false
    t.index ["book_id"], name: "index_books_tags_on_book_id"
    t.index ["tag_id"], name: "index_books_tags_on_tag_id"
  end

  create_table "genres", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "title"
    t.string "seo"
    t.index ["seo"], name: "index_genres_on_seo", unique: true
  end

  create_table "lists", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "title"
    t.text "description"
    t.string "cover"
    t.string "seo"
    t.integer "user_id"
    t.boolean "descriptions", default: false
    t.string "status", default: "unpublished"
    t.index ["seo"], name: "index_lists_on_seo", unique: true
    t.index ["status"], name: "index_lists_on_status"
    t.index ["title"], name: "index_lists_on_title"
    t.index ["user_id"], name: "index_lists_on_user_id"
  end

  create_table "quotes", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.text "text"
    t.integer "user_id"
    t.integer "book_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "hide"
    t.string "book_name"
    t.string "author_name"
    t.index ["book_id"], name: "index_quotes_on_book_id"
    t.index ["user_id"], name: "index_quotes_on_user_id"
  end

  create_table "recomendations", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "book_id"
    t.integer "order", default: 999
  end

  create_table "tags", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "title"
    t.string "seo"
    t.string "uk"
    t.index ["seo"], name: "index_tags_on_seo", unique: true
  end

  create_table "users", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name"
    t.string "role"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

end
