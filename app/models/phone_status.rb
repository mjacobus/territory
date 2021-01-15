# frozen_string_literal: true

class PhoneStatus
  def initialize(phone)
    @phone = phone
  end

  # rubocop:disable Metrics/MethodLength
  def to_s
    if outcomes.empty?
      return 'never_called'
    end

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

    if outcomes.include?('not_home')
      return 'not_home'
    end

    'error'
  end
  # rubocop:enable Metrics/MethodLength

  private

  def outcomes
    @outcomes ||= @phone.outcomes
  end

  def return_visit
    @phone.return_visit
  end

  def return_visit?
    @phone.return_visit?
  end
end
