# frozen_string_literal: true

class SessionsController < ApplicationController
  skip_before_action :require_enabled_user

  def create
    session_service.create_from_oauth(request.env['omniauth.auth'])
    redirect_to(root_url)
  end

  def destroy
    session_service.destroy
    redirect_to(root_url)
  end

  private

  def session_service
    @session_service ||= UserSessionService.new(session:)
  end
end
