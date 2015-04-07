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

ActiveRecord::Schema.define(version: 20141229055604) do

  create_table "game_plays", force: true do |t|
    t.integer  "game_id",                             null: false
    t.integer  "player_id",                           null: false
    t.string   "ffn_standard"
    t.string   "ffn_standard_low"
    t.string   "ffn_standard_high"
    t.string   "ffn_ppr"
    t.string   "ffn_ppr_low"
    t.string   "ffn_ppr_high"
    t.string   "ffn_injury"
    t.string   "ffn_practice_status"
    t.string   "ffn_game_status"
    t.string   "ffn_last_update"
    t.string   "fanduel_salary"
    t.string   "fanduel_pregame_ppg"
    t.string   "fanduel_points"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "rotowire_fanduel_average_fpts"
    t.string   "rotowire_fanduel_projection_fpts"
    t.string   "rotowire_fanduel_previous_week_fpts"
    t.boolean  "home_game"
    t.string   "rotowire_fanduel_projected_value"
    t.string   "fpros_projected_points"
    t.string   "fpros_cost_per_point"
    t.decimal  "spreadsheet_sports_projected_pts"
    t.decimal  "spreadsheet_sports_projected_value"
  end

  create_table "games", force: true do |t|
    t.string   "week"
    t.string   "ffn_game_id"
    t.string   "home_team"
    t.string   "away_team"
    t.string   "location"
    t.datetime "date"
    t.datetime "start_time"
    t.string   "tv_station"
    t.text     "notes"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "winning_team"
  end

  create_table "lineups", force: true do |t|
    t.integer  "week",                   null: false
    t.string   "source",                 null: false
    t.integer  "salary_cap"
    t.integer  "total_salary"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.decimal  "total_projected_points"
    t.decimal  "actual_points"
    t.text     "notes"
  end

  create_table "participations", force: true do |t|
    t.integer  "game_id",    null: false
    t.integer  "team_id",    null: false
    t.boolean  "home_team"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "player_lineups", force: true do |t|
    t.integer  "player_id",  null: false
    t.integer  "lineup_id",  null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "players", force: true do |t|
    t.integer  "team_id"
    t.string   "ffn_player_id"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "display_name"
    t.string   "jersey_number"
    t.string   "position"
    t.string   "height"
    t.string   "weight"
    t.string   "dob"
    t.string   "college"
    t.string   "status"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "teams", force: true do |t|
    t.string   "abbreviation"
    t.string   "full_name"
    t.string   "regional_name"
    t.string   "nickname"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
