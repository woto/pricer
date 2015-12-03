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

ActiveRecord::Schema.define(version: 20151129192522) do

  create_table "prices", force: :cascade do |t|
    t.string   "title"
    t.integer  "supplier_id"
    t.datetime "imported_at"
    t.string   "field_0"
    t.string   "field_1"
    t.string   "field_2"
    t.string   "field_3"
    t.string   "field_4"
    t.string   "field_5"
    t.string   "field_6"
    t.string   "field_7"
    t.string   "field_8"
    t.string   "field_9"
    t.string   "field_10"
    t.string   "field_11"
    t.string   "field_12"
    t.string   "field_13"
    t.string   "field_14"
    t.string   "field_15"
    t.string   "field_16"
    t.string   "field_17"
    t.string   "field_18"
    t.string   "field_19"
    t.string   "field_20"
    t.string   "field_21"
    t.string   "field_22"
    t.string   "field_23"
    t.string   "field_24"
    t.string   "field_25"
    t.string   "field_26"
    t.string   "field_27"
    t.string   "field_28"
    t.string   "field_29"
    t.string   "field_30"
    t.string   "field_31"
    t.string   "field_32"
    t.string   "field_33"
    t.string   "field_34"
    t.string   "field_35"
    t.string   "field_36"
    t.string   "field_37"
    t.string   "field_38"
    t.string   "field_39"
    t.string   "field_40"
    t.string   "field_41"
    t.string   "field_42"
    t.string   "field_43"
    t.string   "field_44"
    t.string   "field_45"
    t.string   "field_46"
    t.string   "field_47"
    t.string   "field_48"
    t.string   "field_49"
    t.string   "field_50"
    t.string   "field_51"
    t.string   "field_52"
    t.string   "field_53"
    t.string   "field_54"
    t.string   "field_55"
    t.string   "field_56"
    t.string   "field_57"
    t.string   "field_58"
    t.string   "field_59"
    t.string   "field_60"
    t.string   "field_61"
    t.string   "field_62"
    t.string   "field_63"
    t.string   "field_64"
    t.string   "field_65"
    t.string   "field_66"
    t.string   "field_67"
    t.string   "field_68"
    t.string   "field_69"
    t.string   "field_70"
    t.string   "field_71"
    t.string   "field_72"
    t.string   "field_73"
    t.string   "field_74"
    t.string   "field_75"
    t.string   "field_76"
    t.string   "field_77"
    t.string   "field_78"
    t.string   "field_79"
    t.string   "field_80"
    t.string   "field_81"
    t.string   "field_82"
    t.string   "field_83"
    t.string   "field_84"
    t.string   "field_85"
    t.string   "field_86"
    t.string   "field_87"
    t.string   "field_88"
    t.string   "field_89"
    t.string   "field_90"
    t.string   "field_91"
    t.string   "field_92"
    t.string   "field_93"
    t.string   "field_94"
    t.string   "field_95"
    t.string   "field_96"
    t.string   "field_97"
    t.string   "field_98"
    t.string   "field_99"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "prices", ["supplier_id"], name: "index_prices_on_supplier_id"

  create_table "searches", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "uploads", force: :cascade do |t|
    t.string   "price"
    t.integer  "job_type"
    t.string   "content_type"
    t.integer  "file_size"
    t.string   "wc"
    t.integer  "tasks_counter"
    t.text     "notes"
    t.text     "command"
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
    t.string   "encoding"
    t.string   "original_filename"
    t.string   "csv_sniffer"
    t.text     "csv_sniffer_result"
    t.text     "python_sniffer_result"
    t.integer  "upload_id"
  end

  add_index "uploads", ["upload_id"], name: "index_uploads_on_upload_id"

end
