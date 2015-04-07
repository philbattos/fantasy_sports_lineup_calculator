class CreateParticipations < ActiveRecord::Migration
  def change
    create_table :participations do |t|
      t.integer :game_id, :null => false
      t.integer :team_id, :null => false

      t.boolean :home_team
      
      t.timestamps
    end
  end
end
