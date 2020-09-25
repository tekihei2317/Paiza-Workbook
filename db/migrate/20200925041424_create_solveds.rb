class CreateSolveds < ActiveRecord::Migration[5.2]
  def change
    create_table :solveds do |t|
      t.references :user, foreign_key: true
      t.references :problem, foreign_key: true

      t.timestamps
    end
  end
end
