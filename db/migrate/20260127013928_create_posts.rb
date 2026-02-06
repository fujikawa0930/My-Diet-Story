class CreatePosts < ActiveRecord::Migration[7.1]
  def change
    create_table :posts do |t|
      t.references :user, null: false, foreign_key: true
      t.text :text
      t.string :location
      t.integer :kind, null: false, default: 0
      t.integer :status, null: false, default: 0
      t.timestamps
    end
  end
end
