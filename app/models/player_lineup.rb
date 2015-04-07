class PlayerLineup < ActiveRecord::Base
  belongs_to :player
  belongs_to :lineup
end