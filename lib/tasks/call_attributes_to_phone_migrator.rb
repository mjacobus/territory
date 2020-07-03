# frozen_string_literal: true

module Tasks
  class CallAttributesToPhoneMigrator
    # complement to migration 20200703145418
    def migrate
      CallAttempt.order(created_at: :desc).each do |call_attempt|
        phone = call_attempt.phone
        phone.name = [phone.name.presence, call_attempt.name.presence].compact.uniq.join(', ')
        phone.gender ||= call_attempt.gender
        phone.save(validate: false)
      end
    end
  end
end
