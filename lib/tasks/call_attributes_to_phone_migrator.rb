# frozen_string_literal: true

module Tasks
  # rubocop:disable Metrics/AbcSize
  class CallAttributesToPhoneMigrator
    # complement to migration 20200703145418
    def migrate
      CallAttempt.order(created_at: :desc).each do |call_attempt|
        phone = call_attempt.phone
        phone.name = [phone.name.presence, call_attempt.name.presence].compact.uniq.join(', ')
        phone.reachable_by = [phone.reachable_by.presence, call_attempt.reachable_by.presence]
          .compact.uniq.join(', ')
        phone.gender ||= call_attempt.gender
        phone.save(validate: false)
      end
    end
    # rubocop:enable Metrics/AbcSize
  end
end
