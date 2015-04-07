class CreateGamePlays < ActiveRecord::Migration
  def change
    create_table :game_plays do |t|
      t.integer :game_id,   :null => false
      t.integer :player_id, :null => false

      t.string :ffn_standard
      t.string :ffn_standard_low
      t.string :ffn_standard_high
      t.string :ffn_ppr
      t.string :ffn_ppr_low
      t.string :ffn_ppr_high
      t.string :ffn_injury
      t.string :ffn_practice_status
      t.string :ffn_game_status
      t.string :ffn_last_update
      t.string :fanduel_salary
      t.string :fanduel_pregame_ppg
      t.string :fanduel_points

      t.timestamps
    end
  end
end
