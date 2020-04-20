# frozen_string_literal: true

class Territory < ApplicationRecord
  MAX_PHONES = 100

  validates :name, presence: true, uniqueness: { case_sensitive: false }
  has_many :phones, dependent: :destroy

  default_scope -> { order(:name) }

  def create_phones(phone_numbers)
    Phone.transaction do
      phone_numbers.each do |phone_number|
        phones.create!(number: phone_number)
      end
    end
  end

  def full?
    phones.count >= MAX_PHONES
  end
end
