# frozen_string_literal: true

class Phone < ApplicationRecord
  belongs_to :territory

  default_scope -> { order(:number) }

  validates :number, presence: true, uniqueness: { case_sensitive: false }

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

  def carrier_variations
    {
      'Oi' => casted_number.with_prefix('014'),
      'TIM' => casted_number.with_prefix('041'),
      'Vivo/Telefônica/GVT' => casted_number.with_prefix('015'),
      'Claro/Net' => casted_number.with_prefix('021')
    }
  end

  private

  def siblings
    territory.phones
  end
end
