class AddProjectedPointsToLineups < ActiveRecord::Migration
  def change
    add_column :lineups, :total_projected_points, :decimal
    add_column :game_plays, :spreadsheet_sports_projected_pts, :decimal
    add_column :game_plays, :spreadsheet_sports_projected_value, :decimal
  end
end
