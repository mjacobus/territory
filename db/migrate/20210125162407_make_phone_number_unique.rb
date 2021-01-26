# frozen_string_literal: true

class MakePhoneNumberUnique < ActiveRecord::Migration[6.1]
  def change
    add_index :phones, :number, unique: true
  end
end
