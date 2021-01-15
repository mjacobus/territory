# frozen_string_literal: true

class Phone < ApplicationRecord
  belongs_to :territory
  has_many :call_attempts, dependent: :destroy

  default_scope -> { order(:number) }

  validates :number, presence: true, uniqueness: { case_sensitive: false }

  def update_status
    self.return_visit = nil

    call_attempts.pluck(:return_visit).compact.each do |return_visit|
      self.return_visit = return_visit
    end

    save!
  end

  def action
    PhoneAction.new(self)
  end

  def casted_number
    PhoneNumber.new(number)
  end

  def next
    ids = siblings.pluck(:id)
    index = ids.index(id)
    next_index = ids[index + 1]
    if next_index.nil?
      next_index = ids.first
    end
    siblings.find(next_index)
  end

  def previous
    ids = siblings.pluck(:id)
    index = ids.index(id)
    previous_index = ids[index - 1]
    if previous_index.nil?
      previous_index = ids.first
    end
    siblings.find(previous_index)
  end

  private

  def siblings
    territory.phones
  end
end
