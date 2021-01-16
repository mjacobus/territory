# frozen_string_literal: true

class DeprecateCallAttemptColumns < ActiveRecord::Migration[6.0]
  def change
    deprecate(:called_annonymously)
    deprecate(:can_text)
    deprecate(:can_call_again)
    deprecate(:has_children)
    deprecate(:answered)
  end

  private

  def deprecate(column_name)
    rename_column :call_attempts, column_name, "#{column_name}_deprecated"
  end
end
