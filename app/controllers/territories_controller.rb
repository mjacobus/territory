class TerritoriesController < ApplicationController
  def index
    @territories = Territory.all
  end
end
