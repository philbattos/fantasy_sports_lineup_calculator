namespace :rotowire do 
  desc "Fetch Rotowite salaries and projections for Fanduel"
  task :fetch_salaries, [:week] => :environment do |task, args|
    require 'nokogiri'
    require 'open-uri'

    url = 'http://www.rotowire.com/daily/nfl/value-report.htm'
    doc = Nokogiri::HTML(open(url))
    valid_text = doc.search("[text()*='Projections, salaries and stats for daily fantasy football leagues on FanDuel.']")

    begin
      new_data = []
      if valid_text.present?
        doc.xpath('//table/tbody/tr').each do |row|
          position              = row.at_xpath('td[1]').text
          last_name, first_name = row.at_xpath('td[2]/a').text.split(', ')
          team_abbreviation     = row.at_xpath('td[3]').text
          home_game             = row.at_xpath('td[5]').text
          salary                = row.at_xpath('td[6]').text.delete('$,')
          projected_points      = row.at_xpath('td[7]').text
          projected_value       = row.at_xpath('td[8]').text
          last_week_points      = row.at_xpath('td[9]').text
          season_average_fpts   = row.at_xpath('td[10]').text

          team_abbreviation     = 'ARI' if team_abbreviation == 'ARZ'

          team      = Team.find_by(abbreviation: team_abbreviation)
          game      = Game.team_and_week(team.id, args[:week]).first
          player    = Player.joins(:team).where(first_name: first_name, last_name: last_name, position: position).where(teams: {abbreviation: team_abbreviation}).first_or_create do |plyr|
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
          game_play.update_column(:rotowire_fanduel_previous_week_fpts, last_week_points)
          game_play.update_column(:rotowire_fanduel_average_fpts, season_average_fpts)

          puts "Game-play ID #{game_play.id} (#{game_play.player.display_name}) updated with Fanduel salary for week #{args[:week]}." 
        end
      else
        puts "Could not find correct text to validate the content of the page. Check the url and contents of the page and try again."
      end
    rescue => e
      puts e
    end
    puts "There were #{new_data.count} new items created: #{new_data}"
  end
end

# => rake rotowire:fetch_salaries[16]


