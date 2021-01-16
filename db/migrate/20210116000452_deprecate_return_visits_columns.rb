# frozen_string_literal: true

class DeprecateReturnVisitsColumns < ActiveRecord::Migration[6.0]
  def change
    rename_column :call_attempts, :return_visit, :return_visit_deprecated
    rename_column :phones, :return_visit, :return_visit_deprecated
  end
end
