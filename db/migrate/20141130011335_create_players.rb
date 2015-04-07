class CreatePlayers < ActiveRecord::Migration
  def change
    create_table :players do |t|
      t.belongs_to :team

      t.string :ffn_player_id
      t.string :first_name
      t.string :last_name
      t.string :display_name
      t.string :jersey_number
      t.string :team
      t.string :position
      t.string :height
      t.string :weight
      t.string :dob
      t.string :college
      t.string :status

      t.timestamps
    end
  end
end
