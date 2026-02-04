class AddKindPosts < ActiveRecord::Migration[7.1]
  def change
    add_column :posts, :kind, :integer, null: false, default: 0
  end
end
