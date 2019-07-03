class CreateWeigths < ActiveRecord::Migration[5.2]
  def change
    create_table :weights do |t|
      t.integer :assignment_id
      t.decimal :weight
      t.string :name
    end
  end
end
