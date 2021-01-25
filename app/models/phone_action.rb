# frozen_string_literal: true

class PhoneAction
  CODE_MAP = {
    0 => :call,
    1 => :return_visit,
    2 => :forget,
    3 => :verify,
    99 => :error
  }.freeze

  attr_reader :code

  def initialize(code)
    @code = code
  end

  delegate :to_s, to: :to_sym

  def to_sym
    CODE_MAP.fetch(code, :error)
  end

  def localized
    I18n.t("app.phone_action.#{to_sym}")
  end
end
