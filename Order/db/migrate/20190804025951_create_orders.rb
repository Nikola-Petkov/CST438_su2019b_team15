class CreateOrders < ActiveRecord::Migration[5.0]
  def change
    create_table :orders do |t|
      t.integer :itemId
      t.string :description
      t.integer :customerId
      t.float :price, default: 0.00
      t.float :award, default: 0.00
      t.float :total, default: 0.00

      t.timestamps
    end
  end
end
