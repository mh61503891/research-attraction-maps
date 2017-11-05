class ResearchesController < ApplicationController

  def index
    render json: Research.get(params[:keywords])
  end

end
