class AddProjectedValueToGamePlays < ActiveRecord::Migration
  def change
    add_column    :game_plays, :rotowire_fanduel_projected_value, :string
    rename_column :game_plays, :rotowire_projection_fpts, :rotowire_fanduel_projection_fpts
    rename_column :game_plays, :rotowire_previous_week_fpts, :rotowire_fanduel_previous_week_fpts
  end
end
