# frozen_string_literal: true

class CallAttempt < ApplicationRecord
  OUTCOMES = %w[not_home contacted unreachable disconnected].freeze
  GENDERS = %w[male female].freeze
  belongs_to :phone
  belongs_to :user

  default_scope -> { order(created_at: :asc) }
  after_save { update_phone_status }

  validates :outcome, presence: true, inclusion: { in: OUTCOMES }
  validates :gender, inclusion: { in: GENDERS, allow_nil: true, allow_blank: true }
  validates :user, presence: true
  validate :validate_contacted_fields

  def contacted?
    outcome.to_s == 'contacted'
  end

  # def gender
  #   raise 'User phone gender'
  # end
  #
  # def name
  #   raise 'User phone name'
  # end

  private

  # rubocop:disable Metrics/MethodLength
  def validate_contacted_fields
    unless contacted?
      return
    end

    unless gender.present?
      errors.add(:gender, :blank)
    end

    unless [true, false].include?(return_visit)
      errors.add(:return_visit, :blank)
    end

    unless notes.present?
      errors.add(:notes, :blank)
    end
  end
  # rubocop:enable Metrics/MethodLength

  def update_phone_status
    unless phone
      return
    end

    phone.call_attempts.pluck(:return_visit).compact.each do |return_visit|
      phone.return_visit = return_visit
    end

    phone.save!
  end
end
