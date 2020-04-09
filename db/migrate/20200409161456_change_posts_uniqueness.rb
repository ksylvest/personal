class ChangePostsUniqueness < ActiveRecord::Migration[6.0]
  def up
    add_index :posts, :slug, unique: true
    remove_index :posts, %i[segment slug]
  end

  def down
    add_index :posts, %i[segment slug], unique: true
    remove_index :posts, :slug
  end
end
