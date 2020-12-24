# frozen_string_literal: true

class HomeController < ApplicationController
  skip_before_action :require_enabled_user

  def index
    if current_user
      @phones_to_return_visit = current_user.return_visits.sort_by do |phone|
        phone.call_attempts.last
      end.reverse
    end
  end
end
