class AddStatusToSubmission < ActiveRecord::Migration[5.2]
  def change
    add_column :submissions, :status, :integer
  end
end
