# frozen_string_literal: true

class ApplicationController < ActionController::Base
  before_action :require_enabled_user
  helper_method :current_user

  rescue_from ActiveRecord::RecordNotFound, with: :render_page404

  private

  def require_enabled_user
    unless current_user
      redirect_to '/'
    end
  end

  def current_user
    @current_user ||= UserSessionService.new(session:).current_user
  end

  def render_page404(_error)
    render 'application/404', status: :not_found
  end
end
