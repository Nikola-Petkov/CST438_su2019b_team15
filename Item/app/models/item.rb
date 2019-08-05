class Item < ApplicationRecord
    validates :price, presence: true
    validates :description, presence: true
    validates :stockQty, presence: true
    
    validates :price, numericality: { greater_than: 0 }
    validates :stockQty, numericality: { only_integer: true, greater_than: 0 }
end