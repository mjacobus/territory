# frozen_string_literal: true

class CreatePhones < ActiveRecord::Migration[6.0]
  def change
    create_table :phones do |t|
      t.string :number
      t.references :territory
      t.boolean :do_not_call, default: false

      t.timestamps
    end
  end
end
