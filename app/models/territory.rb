# frozen_string_literal: true

class Territory < ApplicationRecord
  validates :name, presence: true, uniqueness: { case_sensitive: false }
  has_many :phones

  default_scope -> { order(:name) }

  def create_phones(phone_numbers)
    Phone.transaction do
      phone_numbers.each do |phone_number|
        phones.create!(number: phone_number)
      end
    end
  end
end
