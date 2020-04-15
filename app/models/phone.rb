# frozen_string_literal: true

class Phone < ApplicationRecord
  belongs_to :territory

  validates :number, presence: true, uniqueness: { case_sensitive: false }
end
