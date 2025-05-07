class CreateCombos < ActiveRecord::Migration[8.0]
  def change
    create_table :combos do |t|
      t.references :service, null: false, foreign_key: true
      t.integer :quantity
      t.decimal :discount
      t.decimal :total_price

      t.timestamps
    end
  end
end
