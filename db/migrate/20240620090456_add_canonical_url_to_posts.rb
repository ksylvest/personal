class AddCanonicalUrlToPosts < ActiveRecord::Migration[7.1]
  def change
    add_column :posts, :canonical_url, :string
  end
end
