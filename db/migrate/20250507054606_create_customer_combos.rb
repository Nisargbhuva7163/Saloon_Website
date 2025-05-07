class CreateCustomerCombos < ActiveRecord::Migration[8.0]
  def change
    create_table :customer_combos do |t|
      t.references :customer, null: false, foreign_key: true
      t.references :combo, null: false, foreign_key: true
      t.timestamps
    end
  end
end
