class AddPathToPosts < ActiveRecord::Migration
  def change
    add_column :posts, :path, :string
  end
end
