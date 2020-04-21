# frozen_string_literal: true

class User < ApplicationRecord
  has_many :territories

  def allowed_territories
    if master?
      return Territory.all
    end

    territories
  end
end
