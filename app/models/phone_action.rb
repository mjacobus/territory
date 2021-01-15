# frozen_string_literal: true

class PhoneAction
  CODE_MAP = {
    0 => :call,
    1 => :return_visit,
    2 => :forget,
    3 => :check
  }.freeze

  attr_reader :code

  def initialize(code)
    @code = code
  end

  def to_s
    to_sym.to_s
  end

  def to_sym
    CODE_MAP.fetch(code)
  end
end
