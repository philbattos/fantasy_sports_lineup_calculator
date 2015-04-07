class AddRotowireToGamePlays < ActiveRecord::Migration
  def change
    add_column :game_plays, :rotowire_fanduel_average_fpts, :string
    add_column :game_plays, :rotowire_projection_fpts,      :string
    add_column :game_plays, :rotowire_previous_week_fpts,   :string
    add_column :game_plays, :home_game,                     :boolean
  end
end
