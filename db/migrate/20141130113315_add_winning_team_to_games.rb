class AddWinningTeamToGames < ActiveRecord::Migration
  def change
    add_column :games, :winning_team, :string
  end
end
