# frozen_string_literal: true

class Territory < ApplicationRecord
  validates :name, presence: true, uniqueness: { case_sensitive: false }
  has_many :phones

  default_scope -> { order(:name) }
end
