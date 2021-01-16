# frozen_string_literal: true

class AddMakeReturnVisitToCallAttempts < ActiveRecord::Migration[6.0]
  def change
    add_column :call_attempts, :return_visit, :boolean
    add_column :phones, :return_visit, :boolean
  end
end
