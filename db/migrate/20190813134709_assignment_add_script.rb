class AssignmentAddScript < ActiveRecord::Migration[5.2]
  def change
    add_column :assignments, :script_name, :string, default: './lib/tester.sh', null: false
  end
end
