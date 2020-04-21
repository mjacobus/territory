# frozen_string_literal: true

class PhoneDecorator
  delegate(*Phone.column_names, to: :@phone)
  delegate :to_param, to: :@phone

  def initialize(phone)
    @phone = phone
  end

  def contact_name
    pluck(:name).map(&:to_s).reject(&:empty?).uniq.join(', ')
  end

  def can_text?
    boolean_or(:can_text, true)
  end

  def call_again?
    boolean_or(:can_call_again, true)
  end

  def contacted?
    outcomes.include?('contacted')
  end

  def status
    unless contacted?
      return 'never_called'
    end

    if outcomes.include?('unreachable')
      return 'unreachable'
    end

    unless call_again? || can_text?
      return 'contact_again'
    end

    'do_not_contact_again'
  end

  def contact?
    true
  end

  def to_s
    @phone.to_s
  end

  def outcomes
    @outcomes ||= pluck(:outcome)
  end

  private

  def pluck(field)
    @plucked ||= @phone.call_attempts.pluck(*fields_to_pluck)

    @plucked.map do |fields|
      fields[fields_to_pluck.index(field)]
    end
  end

  def boolean_or(field, _default)
    valid_values = [true, false]
    answer = pluck(field).reverse.find do |value|
      valid_values.include?(value)
    end

    if answer.nil?
      answer = true
    end

    answer
  end

  def fields_to_pluck
    %i[name can_call_again can_text outcome]
  end
end
