class CalculationsController < ApplicationController

  def show
    if params[:players]
      week      = params[:week]
      floor     = params[:floor]
      players   = params[:players]
      qbs       = params[:quarterbacks]
      rbs       = params[:running_backs]
      wrs       = params[:receivers]
      tes       = params[:tight_ends]
      ks        = params[:kickers]
      ds        = params[:defenses]
      positions = [qbs, rbs, wrs, tes, ks, ds].compact

      @game_plays = GamePlay.for_week(week).for_position(positions).rotowire_fanduel_projected_value(floor)
      @combos     = @game_plays.combination(players.to_i)
    else
      raise "Pool size too large!" if params[:pool_size].to_i > 50
      raise "Items number is too large!" if params[:items].to_i > 9
      pool        = params[:pool_size].to_i
      items       = params[:items].to_i
      week        = params[:week].to_i
      salary_cap  = params[:salary_cap]
      lineup_size = params[:lineup_size]
      positions   = params[:positions]
      value_floor = params[:floor]
      quantity    = params[:quantity].to_i

      @combinations = SalaryEngine.new(week).build_rotowire_lineups(salary_cap, value_floor, quantity)
    end
  end
end
