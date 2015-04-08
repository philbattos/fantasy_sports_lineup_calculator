class BaseballController < ApplicationController
  def index
    today = Date.today
    @games = GamedayApi::Game.find_by_date(today.year, today.month, today.day)
  end

  def show
    # obviously need to pull all this out into a BaseballGame model
    year = Date.today.year
    month = Date.today.month
    day = Date.today.day
    year = 2014 # remove this after 2015 becomes viable
    game = GamedayApi::FutureLineScore.new
    gid = params[:id]
    game.load_from_id(gid)
    @pitcher_home = GamedayApi::Pitcher.new
    @pitcher_away = GamedayApi::Pitcher.new
    pitcherid = game.home_pitcher.pid
    pitcher_away_id = game.away_pitcher.pid
    @pitcher_home.load_from_year_id(year, pitcherid)
    @pitcher_away.load_from_year_id(year, pitcher_away_id)

    @home_pitcher_fip = @pitcher_home.fip.round(4)
    @away_pitcher_fip = @pitcher_away.fip.round(4)
    @home_team = game.home_team_name
    @away_team = game.away_team_name

    # #maybe instead get batting average for team against current pitcher (hard to do)

    home_team = GamedayApi::Team.new(game.home_team_abbr)
    away_team = GamedayApi::Team.new(game.away_team_abbr)

    previous_game_h = home_team.games_for_date(year, month+1, day-1) #need to check if there was not a game yesterday
    previous_game_a = away_team.games_for_date(year, month+1, day-1) #remove the +1 here after 2015 gets started

    @pitcher_home.load_from_id(previous_game_h[0].gid, pitcherid)
    @pitcher_away.load_from_id(previous_game_a[0].gid, pitcher_away_id)
  end
end
