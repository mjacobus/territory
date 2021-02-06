# frozen_string_literal: true

class AddLastCalledAt < ActiveRecord::Migration[6.1]
  def change
    add_column :phones, :last_called_at, :datetime, default: nil
  end
end
