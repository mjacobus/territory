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
    phones.where(action_code: 1)
      .order(Phones::SortBy.new(sort_by).to_s)
  end

  def call_history(limit = 50)
    phones.order(last_called_at: :desc).limit(limit).includes(:territory)
  end

  private

  def phones
    territory_ids = Territory.where(user_id: id).select('id')
    Phone
      .unscoped
      .where(territory_id: territory_ids)
  end
end
