# frozen_string_literal: true

class AddUserIdToTerritories < ActiveRecord::Migration[6.0]
  def change
    add_reference :territories, :user, null: true, foreign_key: true
  end
end
