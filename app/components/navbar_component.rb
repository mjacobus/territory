# frozen_string_literal: true

class NavbarComponent < ApplicationComponent
  Item = Struct.new(:url, :text, :active)

  def visible?
    current_user
  end

  def avatar_url
    "#{current_user.avatar}?sz=25"
  end

  def user_name
    current_user.name
  end

  delegate :current_user, to: :helpers

  def items
    standard_items + admin_items
  end

  private

  def standard_items
    [
      Item.new(home_url, home_text, home_active?),
      Item.new(territories_url, territories_text, territories_active?),
      Item.new(random_phone_url, random_phone_text, random_phone_active?),
      Item.new(call_history_path, call_history_text, call_history_active?)
    ]
  end

  def admin_items
    [
      Item.new(users_path, users_text, users_active?)
    ]
  end

  def users_text
    t('app.links.users')
  end

  def users_active?
    controller?(:users)
  end

  def call_history_text
    t('app.links.call_history')
  end

  def call_history_active?
    action?(:call_history)
  end

  def random_phone_text
    t('app.links.random_phone')
  end

  def random_phone_active?
    controller?(:phones) && action?(:random_show)
  end

  def territories_text
    t('app.links.territories')
  end

  def territories_active?
    controller?(:territories)
  end

  def home_url
    root_path(sort_by: 'last_contacted_at.desc')
  end

  def home_text
    t('app.links.home')
  end

  def home_active?
    controller?(:home)
  end

  def controller?(name)
    params[:controller].to_sym == name.to_sym
  end

  def action?(name)
    params[:action].to_sym == name.to_sym
  end
end
