class FixRelationshipsForeignKeys < ActiveRecord::Migration[7.1]
  def up
    # SQLite では外部キー削除が制限されるため、テーブルを再作成して users を参照するようにする
    create_table :relationships_new do |t|
      t.references :follower, null: false, foreign_key: { to_table: :users }
      t.references :followed, null: false, foreign_key: { to_table: :users }
      t.timestamps
    end

    execute "INSERT INTO relationships_new (follower_id, followed_id, created_at, updated_at) SELECT follower_id, followed_id, created_at, updated_at FROM relationships"
    drop_table :relationships
    rename_table :relationships_new, :relationships
  end

  def down
    create_table :relationships_old do |t|
      t.integer :follower_id, null: false
      t.integer :followed_id, null: false
      t.timestamps
    end
    add_index :relationships_old, :follower_id
    add_index :relationships_old, :followed_id

    execute "INSERT INTO relationships_old (follower_id, followed_id, created_at, updated_at) SELECT follower_id, followed_id, created_at, updated_at FROM relationships"
    drop_table :relationships
    rename_table :relationships_old, :relationships
  end
end