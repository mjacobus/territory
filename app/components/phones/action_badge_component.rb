# frozen_string_literal: true

class Phones::ActionBadgeComponent < ApplicationComponent
  def phone
    @phone ||= get(:phone)
  end

  def url
    @url ||= setup_url
  end

  def action
    @action ||= phone.action
  end

  def contact_attempts
    phone.call_attempts_count.to_i
  end

  def badge_class
    {
      return_visit: 'badge-success',
      call: 'badge-light',
      verify: 'badge-warning',
      # not_home: 'badge-warning',
      forget: 'badge-danger',
      error: 'badge-dark'
    }.fetch(action.to_sym)
  end

  private

  def setup_url
    if get(:url) == true
      return territory_phone_path(phone.territory, phone, action_code: phone.action.code)
    end

    get(:url)
  end
end
