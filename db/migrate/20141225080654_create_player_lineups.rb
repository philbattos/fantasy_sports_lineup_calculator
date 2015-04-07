class CreatePlayerLineups < ActiveRecord::Migration
  def change
    create_table :player_lineups do |t|
      t.integer :player_id, :null => false
      t.integer :lineup_id, :null => false

      t.timestamps
    end
  end
end
