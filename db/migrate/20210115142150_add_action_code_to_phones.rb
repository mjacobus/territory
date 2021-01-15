# frozen_string_literal: true

class AddActionCodeToPhones < ActiveRecord::Migration[6.0]
  def change
    add_column :phones, :action_code, :integer, default: 0
  end
end
