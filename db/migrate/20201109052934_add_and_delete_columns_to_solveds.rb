class AddAndDeleteColumnsToSolveds < ActiveRecord::Migration[5.2]
  def change
    remove_column :solveds, :first_score, :integer
    remove_column :solveds, :review_score, :integer
    add_column :solveds, :score, :integer
    add_column :solveds, :first_challenge, :boolean
  end
end
