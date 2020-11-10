class AddColumnsToSolveds < ActiveRecord::Migration[5.2]
  def change
    add_column :solveds, :first_score, :integer
    add_column :solveds, :review_score, :integer
  end
end
