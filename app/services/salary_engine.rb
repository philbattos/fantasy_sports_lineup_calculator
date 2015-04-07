class SalaryEngine
  REQUIRED_POSITIONS = %w[ QB RB RB WR WR WR TE K D ]
  attr_accessor :week, :player_count, :positions

  def initialize(week)
    @week         = week
    @player_count = 7
    @positions    = ['QB', 'RB', 'RB', 'TE', 'WR', 'WR', 'WR']
  end

  def build_rotowire_lineups(salary_max, min_value, number=10)
    gameplays     = find_gameplays(week, positions)
    gpstats       = gameplays.rotowire_fanduel_projected_value(min_value)
                    raise 'too many combinations to calculate' if gpstats.count > 60
    all_combos    = find_all_combos(gpstats, player_count, positions, salary_max)
    sorted_combos = sort_by_rotowire_points(all_combos)
    best_combos   = sorted_combos.last(number)
    gpstats.count

    save_lineups(best_combos, week, salary_max, 'rotowire')
  end

  def build_fantasy_pros_lineups(salary_max, max_cost, number=10)
    gameplays     = find_gameplays(week, positions)
    gpstats       = gameplays.fantasy_pros_projected_value(max_cost)
                    raise 'too many combinations to calculate' if gpstats.count > 60
    all_combos    = find_all_combos(gpstats, player_count, positions, salary_max)
    sorted_combos = sort_by_fantasy_pros_points(all_combos)
    best_combos   = sorted_combos.last(number)

    save_lineups(best_combos, week, salary_max, 'fantasy pros')
  end

  def build_rotowire_and_fpros_lineups(salary_max, min_value, max_cost, number=10)
    gameplays     = find_gameplays(week, positions)
    gpstats       = gameplays.rotowire_fanduel_projected_value(min_value).fantasy_pros_projected_value(max_cost)
                    raise 'too many combinations to calculate' if gpstats.count > 60
    all_combos    = find_all_combos(gpstats, player_count, positions, salary_max)
    # sorted_combos = sort_by_rotowire_points(all_combos)
    sorted_combos = sort_by_fantasy_pros_points(all_combos)
    best_combos   = sorted_combos.last(number)

    save_lineups(best_combos, week, salary_max, 'rotowire & fantasy pros')
  end

  #=================================================
    private
  #=================================================

    def find_gameplays(week, positions)
      GamePlay.for_week(week).for_position(positions)
    end

    def find_all_combos(gameplays, player_count, positions, salary_max)
      gameplays.combination(player_count).select do |combo|
        combo_pos = combo.map {|gp| gp.player.position || 'XX' }.sort
        salaries  = combo.map {|gp| gp.fanduel_salary.gsub(/[$,]/, '').to_i}.inject(0, :+)
        combo_pos == positions && salaries <= salary_max.to_i
      end
    end

    def sort_by_rotowire_points(combos)
      combos.sort_by {|game_plays| game_plays.map { |gp| gp.rotowire_fanduel_projection_fpts.to_f }.inject(0, :+).round(2) }
    end

    def sort_by_fantasy_pros_points(combos)
      combos.sort_by {|game_plays| game_plays.map { |gp| gp.fpros_projected_points.to_f }.inject(0, :+).round(2) }
    end

    def save_lineups(combos, week, salary_max, source)
      combos.each do |combo|
        salary = combo.map {|gp| gp.fanduel_salary.gsub(/[$,]/, '').to_i}.inject(0, :+)
        points = combo.map {|gp| gp.rotowire_fanduel_projection_fpts.to_f.round(2)}.inject(0, :+)
        Lineup.create!(week: week, salary_cap: salary_max, total_salary: salary, total_projected_points: points, source: source).tap do |lineup|
          combo.map {|gp| lineup.players << gp.player}
        end
      end
    end

end

# SalaryEngine.new(17).build_rotowire_lineups(37000, 2.5, 10)
# SalaryEngine.new(17).build_fantasy_pros_lineups(37000, 550, 10)



