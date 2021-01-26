# frozen_string_literal: true

class PhoneNumber
  def initialize(number)
    @number = number.to_s
  end

  def to_s
    @number
  end

  def sanitized
    to_s.gsub(/[^\d]/, '')
  end

  def without_area_code
    sanitized.to_s.last(sanitized.length - 2)
  end

  def with_prefix(prefix)
    self.class.new("#{prefix} #{self}")
  end
end
