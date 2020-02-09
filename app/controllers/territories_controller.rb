# frozen_string_literal: true

class TerritoriesController < ApplicationController
  def index
    @territories = Territory.all
  end
end
