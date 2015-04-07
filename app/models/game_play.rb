class GamePlay < ActiveRecord::Base
  belongs_to  :game
  belongs_to  :player
  # belongs_to  :team

  #-------------------------------------------------
  #    Scopes
  #-------------------------------------------------
  scope :for_week,                          ->(week_number) { joins(:game).where(games: {week: week_number}) }
  scope :for_position,                      ->(positions)   { joins(:player).where(players: {position: positions}) }
  scope :rotowire_fanduel_projected_value,  ->(minimum)     { where('round(rotowire_fanduel_projected_value, 2) >= ?', minimum.to_f)}
  scope :rotowire_fanduel_projected_points, ->(minimum)     { where('round(rotowire_fanduel_projection_fpts, 2) >= ?', minimum.to_f)}
  scope :fantasy_pros_projected_value,      ->(maxcost)     { where.not(fpros_cost_per_point: 'INF').where('round(fpros_cost_per_point, 0) <= ?', maxcost.to_f)}
  scope :fantasy_pros_projected_points,     ->(minimum)     { where('round(fpros_projected_points, 2) >= ?', minimum.to_f)}

  #-------------------------------------------------
  #    Instance Methods
  #-------------------------------------------------
  
  
end