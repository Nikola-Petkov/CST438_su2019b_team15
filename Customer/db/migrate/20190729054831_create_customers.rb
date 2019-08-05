class CreateCustomers < ActiveRecord::Migration[5.0]
  def change
    create_table :customers do |t|
      t.string :email
      t.string :lastName
      t.string :firstName
      t.float :lastOrder, default: 0.00
      t.float :lastOrder2, default: 0.00
      t.float :lastOrder3, default: 0.00
      t.float :award, default: 0.00

      t.timestamps
    end
  end
end
