class Game < ActiveRecord::Base
  # belongs_to :week
  has_many :participations
  has_many :teams,          :through => :participations
  has_many :game_plays
  has_many :players,        :through => :game_plays
  # has_many :fantasy_data

  #-------------------------------------------------
  #    Scopes
  #-------------------------------------------------
  scope :team_and_week, lambda { |team_id, week_number| joins(:teams).where(week: week_number).where(teams: {id: team_id}) }

  #-------------------------------------------------
  #    Instance Methods (Public)
  #-------------------------------------------------
  def team_names
    teams.pluck(:abbreviation)
  end

  def players
    teams.map {|team| team.players}.flatten
  end

end