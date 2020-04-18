# frozen_string_literal: true

class CallAttempt < ApplicationRecord
  OUTCOMES = %w[not_home contacted unreachable disconnected].freeze
  GENDERS = %w[male female].freeze
  belongs_to :phone
  belongs_to :user
  validates :outcome, presence: true, inclusion: { in: OUTCOMES }
  validates :gender, inclusion: { in: GENDERS, allow_nil: true }
  validates :user, presence: true
end
