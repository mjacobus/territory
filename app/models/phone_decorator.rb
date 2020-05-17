# frozen_string_literal: true

class PhoneDecorator
  delegate(*Phone.column_names, to: :@phone)
  delegate :to_param,
           :id,
           :call_attempts,
           :previous,
           :return_visit,
           :return_visit?,
           :carrier_variations,
           :casted_number,
           :next,
           to: :@phone

  def initialize(phone)
    @phone = phone
  end

  def contact_name
    pluck(:name).map(&:to_s).reject(&:empty?).uniq.join(', ')
  end

  def carrier_variations
    {
      'Vivo/Telefônica/GVT' => casted_number.with_prefix('015'),
      'TIM' => casted_number.with_prefix('041'),
      'Oi' => casted_number.with_prefix('014'),
      'Claro/Net' => casted_number.with_prefix('021')
    }
  end

  def contacted?
    outcomes.include?('contacted')
  end

  def notes
    @phone.call_attempts.pluck(:notes).compact
  end

  # rubocop:disable Metrics/MethodLength
  def status
    # Contacted but no feedback
    unless return_visit.nil?
      if return_visit?
        return 'contact_again'
      end

      return 'do_not_contact_again'
    end

    if outcomes.include?('unreachable')
      return 'unreachable'
    end

    unless contacted?
      return 'never_called'
    end

    'error'
  end
  # rubocop:enable Metrics/MethodLength

  def contact?
    true
  end

  def to_s
    @phone.to_s
  end

  def outcomes
    @outcomes ||= pluck(:outcome)
  end

  def badge_text
    I18n.t("app.phone_status.#{status}")
  end

  def badge_class
    {
      contact_again: 'badge-success',
      never_called: 'badge-light',
      unreachable: 'badge-secondary',
      do_not_contact_again: 'badge-danger',
      error: 'badge-danger'
    }.fetch(status.to_sym)
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
    %i[name outcome]
  end
end
