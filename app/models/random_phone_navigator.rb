# frozen_string_literal: true

class RandomPhoneNavigator
  def initialize(user, current = nil)
    @user = user
    @current = current
  end

  def current
    @current ||= random_phone || raise(ActiveRecord::RecordNotFound)
  end

  def previous_url(url_helper)
    url_helper.random_phone_url
  end

  def next_url(url_helper)
    url_helper.random_phone_url
  end

  def previous_label
    I18n.t('app.links.previous_random')
  end

  def next_label
    I18n.t('app.links.next_random')
  end

  private

  def random_phone
    ids = Territory.unscoped.where(user: @user).select(:id)
    query = Phone
      .unscoped
      .order('RANDOM()')
      .where(territory_id: ids, action_code: PhoneAction::CODES[:call])
      .where('last_called_at < ?', 1.day.ago)

    query.first
  end
end
