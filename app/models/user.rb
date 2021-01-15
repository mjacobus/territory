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
    territory_ids = Territory.where(user_id: id).select('id')
    Phone.where(action_code: 1)
      .joins(:call_attempts)
      .where(territory_id: territory_ids)
      .distinct
  end
end
