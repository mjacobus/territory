# frozen_string_literal: true

module Tasks
  class ActionCodeMigrator
    # rubocop:disable Metrics/MethodLength
    def initialize
      reversed_action_code_map = PhoneAction::CODE_MAP.to_a.map do |(key, value)|
        [value, key]
      end.to_h

      status_map = {
        never_called: :call,
        contact_again: :return_visit,
        do_not_contact_again: :forget,
        unreachable: :verify,
        not_home: :call,
        error: :error
      }

      # status: PhoneAction::CODE_MAP key
      @code_map = status_map.to_a.map do |(key, action)|
        [key, reversed_action_code_map.fetch(action)]
      end.to_h
    end
    # rubocop:enable Metrics/MethodLength

    def migrate
      Phone.where(action_code: 0).each do |phone|
        status = PhoneDecorator.new(phone).status.to_sym
        phone.action_code = action_code_from_status(status)
        phone.save(validate: false)
      end
    end

    private

    def action_code_from_status(status)
      @code_map.fetch(status)
    end
  end
end
