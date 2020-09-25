class RenamePasswordColumnToUsers < ActiveRecord::Migration[5.2]
  def change
    rename_column :users, :password, :paiza_password
  end
end
