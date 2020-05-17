# frozen_string_literal: true

module Tasks
  # Complement to migration: 20200517123750
  class ReturnVisitMigrator
    def migrate
      CallAttempt.order(created_at: :desc).each do |call_attempt|
        call_attempt.return_visit = make_return_visit_value(call_attempt)
        call_attempt.save(validate: false)
      end
    end

    def make_return_visit_value(phone)
      values = phone.attributes.slice('can_call_again', 'can_text').values

      if values.include?(true)
        return true
      end

      if values == [false, false]
        return false
      end

      nil
    end
  end
end
