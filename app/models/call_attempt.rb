# frozen_string_literal: true

class CallAttempt < ApplicationRecord
  OUTCOMES = %w[not_home contacted unreachable disconnected].freeze
  GENDERS = %w[male female].freeze
  belongs_to :phone, counter_cache: true
  belongs_to :user

  default_scope -> { order(created_at: :asc) }

  validates :outcome, presence: true, inclusion: { in: OUTCOMES }
  validates :gender, inclusion: { in: GENDERS, allow_blank: true }
  validates :user, presence: true

  def contacted?
    outcome.to_s == 'contacted'
  end
end
