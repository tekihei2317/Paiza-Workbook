class AddPaizaEmailToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :paiza_email, :string
  end
end
