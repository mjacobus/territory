# frozen_string_literal: true

class HomeController < ApplicationController
  skip_before_action :require_enabled_user

  def index
    @phones_to_return_visit = current_user.return_visits
  end
end
