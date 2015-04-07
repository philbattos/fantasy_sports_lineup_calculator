class CreateTeams < ActiveRecord::Migration
  def change
    create_table :teams do |t|
      t.string :abbreviation
      t.string :full_name
      t.string :regional_name
      t.string :nickname

      t.timestamps
    end
  end
end
