class LineupsController < ApplicationController

  def index
    @lineups = Lineup.all
    @week_14_lineups = @lineups.for_week(14)
    @week_15_lineups = @lineups.for_week(15)
    @week_16_lineups = @lineups.for_week(16)
    @week_17_lineups = @lineups.for_week(17)
    @week_18_lineups = @lineups.for_week(18)
    @week_19_lineups = @lineups.for_week(19)
  end

end