# frozen_string_literal: true

class AddLastContactedToPhones < ActiveRecord::Migration[6.1]
  def change
    add_column :phones, :last_contacted_at, :datetime, default: nil
  end
end
