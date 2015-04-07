class CreateGames < ActiveRecord::Migration
  def change
    create_table :games do |t|
      # t.belongs_to :week

      t.string    :week
      t.string    :ffn_game_id
      t.string    :home_team
      t.string    :away_team
      t.string    :location
      t.datetime  :date
      t.datetime  :start_time
      t.string    :tv_station
      t.text      :notes

      t.timestamps
    end
  end
end
