class AttractionsController < ApplicationController

  def index
    render json: Attraction.get
  end

end
