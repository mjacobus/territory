# frozen_string_literal: true

class User < ApplicationRecord
  has_many :territories, dependent: :restrict_with_exception

  def allowed_territories
    if master?
      return Territory.all
    end

    territories
  end

  def return_visits(sort_by: 'last_contacted_at.desc')
    territory_ids = Territory.where(user_id: id).select('id')
    Phone
      .unscoped
      .where(action_code: 1)
      .where(territory_id: territory_ids)
      .order(Phones::SortBy.new(sort_by).to_s)
  end
end
