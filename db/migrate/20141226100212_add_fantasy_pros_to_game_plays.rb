class AddFantasyProsToGamePlays < ActiveRecord::Migration
  def change
    add_column :game_plays, :fpros_projected_points, :string
    add_column :game_plays, :fpros_cost_per_point, :string
  end
end
