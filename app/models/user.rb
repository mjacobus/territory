# frozen_string_literal: true

class User < ApplicationRecord
  has_many :territories

  def allowed_territories
    if master?
      return Territory.all
    end

    territories
  end

  def return_visits
    Phone.where(return_visit: true)
      .joins(:call_attempts)
      .where(call_attempts: { user_id: id }).tap do |sql|
    end
  end
end
