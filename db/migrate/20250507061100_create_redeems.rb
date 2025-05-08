class CreateRedeems < ActiveRecord::Migration[8.0]
  def change
    create_table :redeems do |t|
      t.references :customer_combo, null: false, foreign_key: true
      t.timestamps
    end
  end
end
