class AddSomeAttributesToProblems < ActiveRecord::Migration[5.2]
  def change
    add_column :problems, :average_time, :integer
    add_column :problems, :num_of_people, :integer
    add_column :problems, :acceptance_rate, :float
    add_column :problems, :average_score, :float
  end
end
