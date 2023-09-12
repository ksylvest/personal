class CreatePortfolios < ActiveRecord::Migration[7.0]
  def change
    create_table :portfolios do |t|
      t.string :name, null: false, index: { unique: true }
      t.string :summary, null: false

      t.timestamps
    end
  end
end
