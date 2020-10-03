class AddMinutesSecondsToProblems < ActiveRecord::Migration[5.2]
  def change
    remove_column :problems, :average_time, :integer
    add_column :problems, :average_time_min, :integer
    add_column :problems, :average_time_sec, :integer
  end
end
