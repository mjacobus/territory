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
end
