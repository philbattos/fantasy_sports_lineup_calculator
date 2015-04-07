require 'nokogiri'
require 'open-uri'

class WebScraper
  def self.scrape_rotoguru
    # url = 'http://rotoguru1.com/cgi-bin/fstats.cgi?pos=0&sort=3&game=f&colA=0&daypt=0&xavg=1&inact=0&maxprc=99999&outcsv=0'
    url = 'http://rotoguru1.com/cgi-bin/fstats.cgi?pos=1&sort=3&game=f&colA=0&daypt=0&xavg=1&inact=0&maxprc=99999&outcsv=0'
    doc = Nokogiri::HTML(open(url))
    puts doc
    # doc.css('font').each do |salary|
    #   puts salary.text
    # end
  end

  def self.scrape_fantasy_pros(week)
    player_errors = []
    # iframe1_url = "http://www.fantasyprosnfl.appspot.com/advice_nfl/dfsAnalysis.jsp?site=FD&amp;source=FP"
    iframe2_url = "http://www.fantasyprospartners.appspot.com/fanduelSalaryCap?sport=nfl&week=#{week}&expertId=-1&h=750"
    # url         = 'http://www.fantasypros.com/fanduel-salary-cap-analysis/'

    doc = Nokogiri::HTML(open(iframe2_url))
    valid_text = doc.search("[text()*='FanDuel Salary Cap Cheat Sheet']")
    if valid_text.present?
      doc.xpath('//table/tbody/tr').each do |row|
        name              = row.at_xpath('td[1]/a').text
        difference        = row.at_xpath('td[5]').text
        projected_points  = row.at_xpath('td[6]').text.delete('$,')
        salary            = row.at_xpath('td[7]').text.delete('$,')
        cost_per_point    = row.at_xpath('td[8]').text.delete('$,')

        fix_name_discrepancies(name)
        full_name, team_abbr, position  = name.match(/(.+)[\s][(](.+)[\s][-][\s](.+)[)]/).captures
        team_abbr                       = team_abbr.upcase
        position                        = position.upcase
        split_name                      = full_name.split(' ')
        first_name, last_name           = split_name if split_name.size == 2

        player = Player.joins(:team).where(first_name: first_name, last_name: last_name, position: position).where(teams: {abbreviation: team_abbr}).first
        
        if player.blank?
          player = Player.joins(:team).where(display_name: full_name, position: position).where(teams: {abbreviation: team_abbr}).first
          if player.blank?
            player_errors << name unless position == 'DST'
          end
        end

        if player.present?
          team      = Team.find_by_abbreviation(team_abbr)
          game      = Game.team_and_week(team.id, week).first
          game_play = GamePlay.where(game_id: game.id, player_id: player.id).first_or_create

          game_play.update_column(:fpros_projected_points, projected_points)
          game_play.update_column(:fpros_cost_per_point, cost_per_point)
          game_play.update_column(:fanduel_salary, salary) if game_play.fanduel_salary != salary
        end
      end
    end
    puts player_errors
  end

  def self.scrape_rotowire # this is a rake task: rotowire:fetch_salaries
    url = 'http://www.rotowire.com/daily/nfl/value-report.htm'
    doc = Nokogiri::HTML(open(url))
    # confirm that this is the correct page by checking for this text: 'Projections, salaries and stats for daily fantasy football leagues on FanDuel.'
    test_text = doc.search("[text()*='Projections, salaries and stats for daily fantasy football leagues on FanDuel.']")
    puts 'true' if test_text
    puts 'present' if test_text.present?
    doc.xpath('//table/tbody/tr').each do |row|
      name        = row.at_xpath('td[2]/a').text
      team        = row.at_xpath('td[3]').text
      salary      = row.at_xpath('td[6]').text
      projection  = row.at_xpath('td[7]').text
      value       = row.at_xpath('td[8]').text
      last_week   = row.at_xpath('td[9]').text
      season      = row.at_xpath('td[10]').text
      puts "#{name} - #{salary}, #{team}, #{projection}, #{value}, #{last_week}, #{season}"
    end
  end

  def self.scrape_spreadsheet_sports(week)
    unfound_players = []
    url = 'https://www.spreadsheet-sports.com/projections/nfl-daily-fantasy-football-projections/?chart=fanduel'
    doc = Nokogiri::HTML(open(url))
    valid_text = doc.search("[text()*='NFL Fantasy Football Projections']")
    if valid_text.present?
      qbs = doc.css('#sheet_div_0 table tr')
      qbs.each do |row|
        name        = row.css('td[2]').text.sub(/('.td.'>)/, '')
        projection  = row.css('td[12]').text.sub(/('.td.'>)/, '')
        salary      = row.css('td[13]').text.sub(/('.td.'>)/, '')
        value       = row.css('td[14]').text.sub(/('.td.'>)/, '')
        position    = 'QB'

        players = Player.where(display_name: name).where(position: position)
        if players.count == 1
          player = players.first
        #   game      = player.games.find_by_week(week)
        #   game_play = GamePlay.where(game_id: game.id, player_id: player.id).first_or_create

        #   game_play.update_column(spreadsheet_sports_projected_pts: projection)
        #   game_play.update_column(spreadsheet_sports_projected_value: value)
        #   game_play.update_column(:fanduel_salary, salary) if game_play.fanduel_salary != salary
        # else
        #   unfound_players << "#{name}, #{position}, #{salary}"
          puts "#{player.id}, #{name}, #{salary}, #{projection}, #{value}"
        end
      end

      rbs = doc.css('#sheet_div_1')
      qbs.each do |row|
        name        = row.css('td[2]').text.sub(/('.td.'>)/, '')
        projection  = row.css('td[12]').text.sub(/('.td.'>)/, '')
        salary      = row.css('td[13]').text.sub(/('.td.'>)/, '')
        value       = row.css('td[14]').text.sub(/('.td.'>)/, '')
        position    = 'RB'

        players = Player.where(display_name: name).where(position: position)
        if players.count == 1
          player = players.first
        #   game      = player.games.find_by_week(week)
        #   game_play = GamePlay.where(game_id: game.id, player_id: player.id).first_or_create

        #   game_play.update_column(spreadsheet_sports_projected_pts: projection)
        #   game_play.update_column(spreadsheet_sports_projected_value: value)
        #   game_play.update_column(:fanduel_salary, salary) if game_play.fanduel_salary != salary
        # else
        #   unfound_players << "#{name}, #{position}, #{salary}"
          puts "#{player.id}, #{name}, #{salary}, #{projection}, #{value}"
        end
      end

      wrs = doc.css('#sheet_div_2')
      tes = doc.css('#sheet_div_3')
      dfs = doc.css('#sheet_div_4')
      ks  = doc.css('#sheet_div_5')
      # puts qbs
      # puts qbs.first
      # puts qbs.count
    end
  end

  def self.fix_name_discrepancies(name)
    discrepancies = {
      'Benny Cunningham (STL - RB)' => 'Benjamin Cunningham (STL - RB)',
      'Ted Ginn (ARI - WR)'         => 'Ted Ginn Jr. (ARI - WR)',
      'Ben Watson (NO - TE)'        => 'Benjamin Watson (NO - TE)'
    }
    if discrepancies.keys.include? name
      name.gsub!(name, discrepancies[name])
    end
  end

end