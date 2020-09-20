class CreateProblems < ActiveRecord::Migration[5.2]
  def change
    create_table :problems do |t|
      t.string :rank
      t.integer :number
      t.string :name
      t.string :url
      t.integer :difficulty

      t.timestamps
    end
  end
end
