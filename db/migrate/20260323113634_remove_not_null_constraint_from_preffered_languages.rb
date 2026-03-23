class RemoveNotNullConstraintFromPrefferedLanguages < ActiveRecord::Migration[8.1]
  def change
    change_column_null :account_preffered_languages, :priority, true
  end
end
