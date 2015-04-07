class AddActualPointsToLineups < ActiveRecord::Migration
  def change
    add_column :lineups, :actual_points, :decimal
    add_column :lineups, :notes, :text
  end
end
