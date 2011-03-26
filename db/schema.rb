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

ActiveRecord::Schema.define(:version => 20100603230048) do

  create_table "choices", :force => true do |t|
    t.string   "slug"
    t.integer  "location_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "favourite_route_id"
  end

  create_table "lines", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "terminal_a"
    t.string   "terminal_b"
    t.integer  "emt_code"
  end

  create_table "locations", :force => true do |t|
    t.string   "name"
    t.string   "emt_code"
    t.float    "lng"
    t.float    "lat"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "locations", ["emt_code"], :name => "index_locations_on_emt_code"
  add_index "locations", ["lat"], :name => "index_locations_on_lat"
  add_index "locations", ["lng"], :name => "index_locations_on_lng"

  create_table "routes", :force => true do |t|
    t.string   "destination"
    t.integer  "line_id"
    t.string   "name"
    t.string   "emt_line"
    t.string   "direction"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "origin"
  end

  create_table "stops", :force => true do |t|
    t.integer  "route_id"
    t.integer  "location_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "total_distance"
    t.integer  "prev_distance"
  end

  add_index "stops", ["location_id"], :name => "index_stops_on_location_id"
  add_index "stops", ["route_id"], :name => "index_stops_on_route_id"

end
