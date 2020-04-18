# frozen_string_literal: true

class CreateCallAttempts < ActiveRecord::Migration[6.0]
  def change
    create_table :call_attempts do |t|
      t.string :outcome, index: true
      t.string :name
      t.references :user
      t.references :phone
      t.text :notes
      t.integer :age
      t.boolean :answered
      t.string :gender
      t.boolean :has_children
      t.boolean :can_text
      t.boolean :can_call_again
      t.boolean :called_annonymously
      t.text :reachable_by

      t.timestamps
    end
  end
end
