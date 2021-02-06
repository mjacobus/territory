# frozen_string_literal: true

class Phone < ApplicationRecord
  belongs_to :territory
  has_many :call_attempts, dependent: :destroy

  default_scope -> { order(:number) }

  validates :number, presence: true, uniqueness: { case_sensitive: false }

  def action
    PhoneAction.new(action_code)
  end

  def casted_number
    PhoneNumber.new(number)
  end

  def next(siblings = territory.phones)
    navigator = ArrayNavigator.new(siblings.pluck(:id), current: id)
    siblings.find(navigator.next)
  end

  def previous(siblings = territory.phones)
    navigator = ArrayNavigator.new(siblings.pluck(:id), current: id)
    siblings.find(navigator.previous)
  end

  def update_status
    last_call_attempt = call_attempts.reorder(created_at: :desc).limit(1)

    self.last_called_at = last_call_attempt.pick(:created_at)
    self.last_contacted_at = last_call_attempt
      .where(outcome: :contacted)
      .pick(:created_at)

    save(validate: false)
  end
end
