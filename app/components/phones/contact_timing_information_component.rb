# frozen_string_literal: true

class Phones::ContactTimingInformationComponent < ApplicationComponent
  attr_reader :phone

  def initialize(phone)
    @phone = phone
  end

  def show_contacted?
    phone.last_contacted_at.present?
  end

  def contacted_time
    l(phone.last_contacted_at, format: :short)
  end

  def contacted_time_ago
    time_ago(phone.last_contacted_at)
  end

  def show_contacted_attempt?
    if phone.last_called_at.nil?
      return false
    end

    phone.last_called_at != phone.last_contacted_at
  end

  def last_attempt_time
    l(phone.last_called_at, format: :short)
  end

  def last_attempt_time_ago
    time_ago(phone.last_called_at)
  end

  def two_times?
    @two_times ||= [phone.last_contacted_at, phone.last_called_at].compact.uniq.length > 1
  end
end
