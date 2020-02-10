# frozen_string_literal: true

class TerritoriesController < ApplicationController
  def index
    @territories = Territory.all
  end

  def new
    @territory = Territory.new
  end

  def create
    @territory = Territory.new(territory_params)

    if @territory.save
      redirect_to(territories_path)
      return
    end

    render :new
  end

  private

  def territory_params
    params.require(:territory).permit(:name)
  end
end
