# frozen_string_literal: true

class AddCallAttemptsCountToPhones < ActiveRecord::Migration[6.0]
  def change
    add_column :phones, :call_attempts_count, :integer, default: 0
    Phone.reset_column_information
    Phone.find_each do |p|
      Phone.reset_counters p.id, :call_attempts
    end
  end
end
