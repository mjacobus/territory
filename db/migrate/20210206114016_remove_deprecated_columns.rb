# frozen_string_literal: true

# rubocop:disable Rails/ReversibleMigration
class RemoveDeprecatedColumns < ActiveRecord::Migration[6.1]
  def change
    remove_column :call_attempts, :answered_deprecated
    remove_column :call_attempts, :has_children_deprecated
    remove_column :call_attempts, :can_text_deprecated
    remove_column :call_attempts, :can_call_again_deprecated
    remove_column :call_attempts, :called_annonymously_deprecated
    remove_column :call_attempts, :return_visit_deprecated
    remove_column :phones, :return_visit_deprecated
  end
end
# rubocop:enable Rails/ReversibleMigration
