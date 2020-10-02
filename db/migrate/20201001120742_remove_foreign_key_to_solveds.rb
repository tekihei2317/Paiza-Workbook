class RemoveForeignKeyToSolveds < ActiveRecord::Migration[5.2]
  def change
    remove_foreign_key :solveds, :users
    remove_foreign_key :solveds, :problems
  end
end
