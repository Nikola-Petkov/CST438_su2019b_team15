class Customer < ApplicationRecord
    validates :email, presence: true
    validates :firstName, presence: true
    validates :lastName, presence: true
    
    validates :email, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i, message: "Invalid email" }
    validates_uniqueness_of :email, case_sensitive: false, message: "Email already registered!"
end
