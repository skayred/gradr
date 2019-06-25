class CreateTestReps < ActiveRecord::Migration[5.2]
  def change
    create_table :test_reps do |t|
      t.string :name
      t.integer :assignment_id

      t.timestamps
    end
  end
end
