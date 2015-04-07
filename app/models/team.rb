class Team < ActiveRecord::Base
  has_many :participations
  has_many :games,          :through => :participations
  has_many :players
  # has_many :game_plays
end