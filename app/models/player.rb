class Player < ActiveRecord::Base
  belongs_to  :team
  has_many    :game_plays
  has_many    :games,         :through => :game_plays
  has_many    :player_lineups
  has_many    :lineups,       :through => :player_lineups

  #-------------------------------------------------
  #    Instance Methods (Public)
  #-------------------------------------------------
  def find_ffn_score(week)
    game_plays.for_week(week).first.ffn_standard.to_f.round(2)
  end

  def find_ffn_floor(week)
    game_plays.for_week(week).first.ffn_standard_low.to_f.round(2)
  end

  def find_ffn_ceiling(week)
    game_plays.for_week(week).first.ffn_standard_high.to_f.round(2)
  end

  def find_ffn_downside(week)
    (find_ffn_score(week) - find_ffn_floor(week)).round(2)
  end

  def find_ffn_upside(week)
    (find_ffn_ceiling(week).to_f - find_ffn_score(week)).round(2)
  end

  def find_ffn_ppr(week)
    game_plays.for_week(week).first.ffn_ppr
  end

  def find_ffn_ppr_floor(week)
    game_plays.for_week(week).first.ffn_ppr_low
  end

  def find_ffn_ppr_ceiling(week)
    game_plays.for_week(week).first.ffn_ppr_high
  end

  def find_ffn_ppr_downside(week)
    (find_ffn_ppr(week).to_f - find_ffn_ppr_floor(week).to_f).round(2)
  end

  def find_ffn_ppr_upside(week)
    (find_ffn_ppr_ceiling(week).to_f - find_ffn_ppr(week).to_f).round(2)
  end
end