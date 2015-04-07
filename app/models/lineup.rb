class Lineup < ActiveRecord::Base
  has_many :player_lineups
  has_many :players,        :through => :player_lineups

  #-------------------------------------------------
  #    Scopes
  #-------------------------------------------------
  scope :for_week, ->(week_number) { where(week: week_number) }

end