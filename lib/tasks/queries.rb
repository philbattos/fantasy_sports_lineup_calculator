# queries to help calculate lineup calculations

# TO DO: before combination query, convert number fields to integers or floats (are there any calculations that can be done before query runs?)

# To execute raw SQL
sql = "SELECT * FROM teams"
Team.connection.execute(sql)

# Raw SQL examples
combinations_of_teams = "SELECT a.id, b.id FROM teams a CROSS JOIN teams b" # generates all the combinations of the teams, including each team combined with itself
all_quarterbacks = "SELECT id FROM players WHERE position = 'QB'"
combinations_of_running_backs = "SELECT a.id, b.id FROM (SELECT id FROM players WHERE position = 'RB') a CROSS JOIN (SELECT id FROM players WHERE position = 'RB') b WHERE a.id != b.id"
  # the combinations of running backs, above, includes duplicates
  Player.where(position: 'RB').to_a.combination(2)
  Player.where(position: 'WR').to_a.combination(3)

qbs = Player.joins(:game_plays => :game).where(position: 'QB').where(games: {week: '16'})
rbs = Player.where(position: 'RB')
wrs = Player.where(position: 'WR')
tes = Player.where(position: 'TE')
ks = Player.where(position: 'K')
# ds = Player.where(position: 'D')

singles = qbs + tes + ks + ds
combos = singles.combination(4).select {|combo| combo.map {|player| player.position}.sort == ['D', 'K', 'QB', 'TE']}

players = qbs + rbs + wrs + tes + ks + ds
players.combination(8).select {|combo| combo.map {|player| player.position}.sort == ['K', 'QB', 'RB', 'RB', 'TE', 'WR', 'WR', 'WR']}.count

game_plays = GamePlay.joins(:player, :game).where(games: {week: '16'}).where(players: {position: ['QB', 'RB', 'WR']}).where('rotowire_fanduel_projected_value > 2.1')
game_plays.combination(5).select {|combo| (combo.map {|gp| gp.player.position}.sort == ['QB', 'RB', 'RB', 'WR', 'WR']) && (combo.inject(0){|sum,player| player.fanduel_salary.gsub(/[$,]/, '').to_i + sum} < 37000) }.sort_by {|gp| gp.inject(0){|sum,player| player.rotowire_fanduel_projection_fpts.to_f + sum}}.last(10)

# {"Dez Bryant"=>8, "Peyton Manning"=>1, "Julian Edelman"=>7, "Doug Martin"=>7, "Branden Oliver"=>7, "Aaron Rodgers"=>3, "Tre Mason"=>4, "Larry Fitzgerald"=>1, "Drew Brees"=>1, "Matt Asiata"=>2, "Jordy Nelson"=>3, "Matt Ryan"=>4, "Matthew Stafford"=>1, "A.J. Green"=>1}
# Dez Bryant, Julian Edelman, Doug Martin, Branden Oliver, Matt Ryan, Tre Mason

# GamePlay IDs with highest collected points (for 1 QB, 2 RBs, 2 WRs):
# NOTE: highest projected points are last 
  [
    [6847, 6849, 6860, 6908, 6912], 
    [6846, 6847, 6882, 6885, 6908], 
    [6847, 6858, 6860, 6893, 6908], 
    [6847, 6848, 6861, 6908, 6912], 
    [6848, 6860, 6861, 6882, 6912], 
    [6847, 6860, 6861, 6882, 6912], 
    [6847, 6848, 6864, 6893, 6912], 
    [6847, 6860, 6861, 6882, 6908], 
    [6846, 6852, 6860, 6908, 6912], 
    [6846, 6847, 6860, 6908, 6912]
  ]

# conditions:
# => Saturday, Sunday, and Monday games 
# => QB, RB, RB, WR, WR for 37500 or less



