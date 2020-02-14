# frozen_string_literal: true

class HomeController < ApplicationController
  skip_before_action :require_enabled_user

  def index; end
end
