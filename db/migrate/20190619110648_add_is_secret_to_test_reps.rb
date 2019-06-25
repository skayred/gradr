class AddIsSecretToTestReps < ActiveRecord::Migration[5.2]
  def change
    add_column :test_reps, :is_secret, :boolean
  end
end
