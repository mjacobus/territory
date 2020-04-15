# frozen_string_literal: true

class TerritoriesController < ApplicationController
  def index
    @territories = Territory.all
  end

  def show
    territory
  end

  def new
    @territory = Territory.new
  end

  def edit
    territory
  end

  def create
    @territory = Territory.new(territory_params)

    if @territory.save
      redirect_to(territories_path)
      return
    end

    render :new
  end

  def update
    territory.attributes = territory_params

    if territory.save
      redirect_to(territories_path)
      return
    end

    render :edit
  end

  def destroy
    territory.destroy
    redirect_to(territories_path)
  end

  private

  def territory
    @territory ||= Territory.find(params[:id])
  end

  def territory_params
    params.require(:territory).permit(:name)
  end
end
