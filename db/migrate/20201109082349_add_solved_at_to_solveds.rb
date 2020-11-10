class AddSolvedAtToSolveds < ActiveRecord::Migration[5.2]
  def change
    add_column :solveds, :solved_at, :datetime
  end
end
