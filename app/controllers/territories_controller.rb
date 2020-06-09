# frozen_string_literal: true

class TerritoriesController < ApplicationController
  def index
    @territories = territories.all
  end

  def new
    @territory = territories.build
  end

  def edit
    territory
  end

  def create
    @territory = territories.build(territory_params)

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

  def territories
    current_user.allowed_territories
  end

  def territory
    @territory ||= territories.find(params[:id])
  end

  def territory_params
    param_names = [:name]
    if current_user.master?
      param_names << :user_id
    end
    params.require(:territory).permit(*param_names)
  end
end
