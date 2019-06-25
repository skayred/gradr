class AddCooldownToAssignments < ActiveRecord::Migration[5.2]
  def change
    add_column :assignments, :cooldown, :integer
  end
end
