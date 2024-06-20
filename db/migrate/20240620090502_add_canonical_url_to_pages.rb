class AddCanonicalUrlToPages < ActiveRecord::Migration[7.1]
  def change
    add_column :pages, :canonical_url, :string
  end
end
