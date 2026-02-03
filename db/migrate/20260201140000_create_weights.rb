class CreateWeights < ActiveRecord::Migration[7.1]
  def change
    create_table :weights do |t|
      t.references :user, null: false, foreign_key: true
      t.date :date, null: false
      t.decimal :value, precision: 5, scale: 2, null: false

      t.timestamps
    end

    add_index :weights, [:user_id, :date], unique: true
  end
end
