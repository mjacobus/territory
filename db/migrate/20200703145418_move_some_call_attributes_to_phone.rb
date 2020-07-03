# frozen_string_literal: true

class MoveSomeCallAttributesToPhone < ActiveRecord::Migration[6.0]
  def change
    add_column :phones, :name, :string
    add_column :phones, :gender, :string
    Tasks::CallAttributesToPhoneMigrator.new.migrate
  end
end
