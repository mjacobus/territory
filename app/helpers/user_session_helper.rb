# frozen_string_literal: true

module UserSessionHelper
  def current_user
    @current_user ||= UserSessionService.new(session: session).current_user
  end
end
