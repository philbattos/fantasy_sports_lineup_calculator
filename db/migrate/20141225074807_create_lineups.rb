class CreateLineups < ActiveRecord::Migration
  def change
    create_table :lineups do |t|
      t.integer :week,      :null => false
      t.string  :source,    :null => false
      t.integer :salary_cap
      t.integer :total_salary

      t.timestamps
    end
  end
end
