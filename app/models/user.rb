# frozen_string_literal: true

class User < ApplicationRecord
  has_many :territories, dependent: :restrict_with_exception

  def allowed_territories
    if master?
      return Territory.all
    end

    territories
  end

  def return_visits
    territory_ids = Territory.where(user_id: id).select('id')
    phones = Phone.where(action_code: 1)
      .joins(:call_attempts)
      .where(territory_id: territory_ids)
      .distinct

    phones.sort_by do |phone|
      phone.call_attempts.last.created_at
    end.reverse
  end
end
