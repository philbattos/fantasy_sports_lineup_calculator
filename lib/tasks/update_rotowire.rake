namespace :rotowire do 
  desc "Fetch Rotowite salaries and projections for Fanduel"
  task :update_salaries => :environment do |task, args|

    # validation_text

    url       = "https://www.kimonolabs.com/api/9wab1gw4?apikey=uFejjaA6hHJGMbIpG0NRwSrewvYtJ4Zz"
    response  = RestClient.get url
    rotowire  = JSON.parse(response)

    name      = rotowire['name']
    count     = rotowire['count']
    frequency = rotowire['frequency']
    newdata   = rotowire['newdata']
    results   = rotowire['results']
    players   = results['Rotowire Projections']
    week      = results['collection2'].first['Title'].split('Week ').last

    begin
      new_data = []
      players.each do |rotowire_player|
        last_name, first_name = rotowire_player['Player']['text'].split(', ')
        position              = rotowire_player['Position']
        team_abbr             = rotowire_player['Team']
        opponent              = rotowire_player['Opponent']
        home_game             = rotowire_player['Home/Away']
        salary                = rotowire_player['Fanduel Salary'].delete('$,').to_i
        projected_points      = rotowire_player['Projected Points'].to_f
        projected_value       = rotowire_player['Projected Value'].to_f

        team_abbr = 'ARI' if team_abbr == 'ARZ'

        team      = Team.find_by(abbreviation: team_abbr)
        game      = Game.team_and_week(team.id, week).first
        player    = Player.joins(:team).where(first_name: first_name, last_name: last_name, position: position).where(teams: {abbreviation: team_abbr}).first_or_create do |plyr|
          new_data << "New Player: #{plyr.first_name} #{plyr.last_name}"
        end
        game_play = GamePlay.where(game_id: game.id, player_id: player.id).first_or_create do |gp|
          new_data << "New GamePlay: #{player.first_name} #{player.last_name}"
        end

        home = true   if home_game == 'Home'
        home = false  if home_game == 'Away'
        game_play.update_column(:fanduel_salary, salary) if game_play.fanduel_salary.nil?
        game_play.update_column(:home_game, home)
        game_play.update_column(:rotowire_fanduel_projection_fpts, projected_points)
        game_play.update_column(:rotowire_fanduel_projected_value, projected_value)
        # game_play.update_column(:rotowire_fanduel_previous_week_fpts, last_week_points)
        # game_play.update_column(:rotowire_fanduel_average_fpts, season_average_fpts)

        puts "Game-play ID #{game_play.id} (#{game_play.player.display_name}) updated with Fanduel salary for week #{week}." 
      end
    rescue => e
      puts e
    end
    puts "There were #{new_data.count} new items created: #{new_data}"
    # if new_data.present? # save to csv or send alert
  end
end

# => rake rotowire:update_salaries


