class FantasyFootballNerd

  def self.retrieve_nfl_teams
    url = base_url + "/nfl-teams/json/#{ffn_api_key}"
    response = RestClient.get url, accept: :json
    save_team_data(response) if response.code == 200
    # FFNerd.api_key = ffn_api_key
    # FFNerd.teams
  end

  def self.retrieve_nfl_schedule
    url = base_url + "/schedule/json/#{ffn_api_key}"
    response = RestClient.get(url, accept: :json)
    puts response
    save_games(response) if response.code == 200
    # FFNerd.api_key = ffn_api_key
    # FFNerd.schedule
  end

  def self.retrieve_nfl_players
    url = base_url + "/players/json/#{ffn_api_key}"
    response = RestClient.get url, accept: :json
    save_player_data(response) if response.code == 200
  end

  def self.retrieve_nfl_player_rankings(week, position)
    # NOTE: acceptable positions: QB, RB, WR, TE, K, DEF
    url = base_url + "/weekly-rankings/json/#{ffn_api_key}/#{position}/#{week}/1"
    response = RestClient.get url, accept: :json
    save_weekly_rankings(response) if response.code == 200
  end

  #=================================================
    private
  #=================================================
  
    def self.base_url
      'http://fantasyfootballnerd.com/service'
    end

    def self.ffn_api_key
      'zmh3jzv6w2uv'
    end

    def self.save_team_data(response)
      ffn_teams = JSON.parse(response)
      teams     = ffn_teams['NFLTeams']
      teams.map do |team|
        Team.find_or_create_by(abbreviation: team['code'], full_name: team['fullName'], regional_name: team['shortName'])
      end
    end

    def self.save_games(response)
      ffn_schedules = JSON.parse(response)
      schedules     = ffn_schedules['Schedule']
      schedules.map do |schedule|
        Game.where( week: schedule['gameWeek'], 
                    home_team: schedule['homeTeam'], 
                    away_team: schedule['awayTeam'] ).first_or_create do |game|
          game.ffn_game_id  = schedule['gameId']
          game.date         = schedule['gameDate']
          game.start_time   = schedule['gameTimeET']
          game.tv_station   = schedule['tvStation']
          game.winning_team = schedule['winner']
        end
      end
    end

    def self.save_player_data(response)
      ffn_players = JSON.parse(response)
      players     = ffn_players['Players']
      players.map do |player|
        team = Team.where(abbreviation: player['team']).first
        Player.find_or_create_by( ffn_player_id:  player['playerId'],
                                  first_name:     player['fname'],
                                  last_name:      player['lname'] ) do |new_player|
          new_player.status = 'active' if player['active'] == '1'
          new_player.display_name   =  player['displayName']
          new_player.jersey_number  =  player['jersey']
          new_player.position       =  player['position']
          new_player.height         =  player['height']
          new_player.weight         =  player['weight']
          new_player.dob            =  player['dob']
          new_player.college        =  player['college']
          new_player.team_id        =  team.id if team
        end
      end
    end

    def self.save_weekly_rankings(response)
      begin
        ffn_rankings  = JSON.parse(response)
        rankings      = ffn_rankings['Rankings']
        rankings.map do |ranking|
          game    = Game.where(week: ranking['week']).where('home_team=? OR away_team=?', ranking['team'], ranking['team']).first
          if ranking['playerId']
            player  = Player.find_by_ffn_player_id ranking['playerId']
          else
            player  = Player.joins(:team).where(display_name: ranking['name']).where(team: {abbreviation: ranking['team']}).first
          end
          GamePlay.where(game_id: (game ? game.id : 0), player_id: player.id).first_or_create do |gp|
            gp.ffn_standard        = ranking['standard']
            gp.ffn_standard_low    = ranking['standardLow']
            gp.ffn_standard_high   = ranking['standardHigh']
            gp.ffn_ppr             = ranking['ppr']
            gp.ffn_ppr_low         = ranking['pprLow']
            gp.ffn_ppr_high        = ranking['pprHigh']
            gp.ffn_injury          = ranking['injury']
            gp.ffn_practice_status = ranking['practiceStatus']
            gp.ffn_game_status     = ranking['gameStatus']
            gp.ffn_last_update     = ranking['lastUpdate']
          end
        end
      rescue => e
        puts e
      end
    end

end



