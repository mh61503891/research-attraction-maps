class Attraction < ApplicationRecord

  def self.get
    RESAS.attractions
  end

end
