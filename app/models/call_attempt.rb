# frozen_string_literal: true

class CallAttempt < ApplicationRecord
  OUTCOMES = %w[not_home contacted unreachable disconnected].freeze
  GENDERS = %w[male female].freeze
  belongs_to :phone
  belongs_to :user
  validates :outcome, presence: true, inclusion: { in: OUTCOMES }
  validates :gender, inclusion: { in: GENDERS, allow_nil: true, allow_blank: true }
  validates :user, presence: true

  validate :validate_contacted_fields

  def contacted?
    outcome.to_s == 'contacted'
  end

  private

  def validate_contacted_fields
    unless contacted?
      return
    end

    unless gender.present?
      errors.add(:gender, :blank)
    end

    unless notes.present?
      errors.add(:notes, :blank)
    end
  end
end
