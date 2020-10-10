class RemovePaizaInfoToUsers < ActiveRecord::Migration[5.2]
  def change
    remove_column :users, :paiza_email, :string
    remove_column :users, :paiza_password, :string
  end
end
