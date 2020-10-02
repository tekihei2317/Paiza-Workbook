class ChangeDatatypeRankOfProblems < ActiveRecord::Migration[5.2]
  def change
    change_column :problems, :rank, :integer
  end
end
