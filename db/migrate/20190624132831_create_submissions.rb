class CreateSubmissions < ActiveRecord::Migration[5.2]
  def change
    create_table :submissions do |t|
      t.string :jid
      t.integer :user_id
      t.integer :assignment_id
      t.integer :score
      t.text    :feedback

      t.timestamps
    end
  end
end
