class CreateItems < ActiveRecord::Migration[5.0]
  def change
    create_table :items do |t|
      t.text :description
      t.decimal :price
      t.integer :stockQty

      t.timestamps
    end
  end
end
