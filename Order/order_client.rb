require 'httparty'
require_relative 'app/models/customer.rb'
require_relative 'app/models/item.rb'

class OrderClient
    include HTTParty
    
    base_uri "http://localhost:8080"
    format :json
    
    def self.register(cust)
        Customer.register(cust)
    end
    
    def self.createItem(item)
        post '/items', body: item.to_json,
            headers: { 'Content-Type' => 'application/json', 'ACCEPT' => 'application/json' }
    end
    
    def self.getCustomer(cust)
        Customer.getCustomer(cust)
    end
    
    def self.getOrder(id)
        get "/orders/#{id}"
    end
    
    def self.getItem(id)
        Item.getItemById(id)
    end
    
    def self.newOrder(data)
        post "/orders", body: data.to_json,
            headers: { 'Content-Type' => 'application/json', 'ACCEPT' => 'application/json' }
    end
end

while true
    puts "What do you want to do: (1) Register customer, (2) Create item, (3) Purchase, 
          (4) Lookup customer, (5) Lookup item, (6) Lookup order, (0) Quit."
    input = gets.chomp!
    case input
    when '0'
        puts "Goodbye."
        break
    when '1'
        puts "Register a new customer. Enter lastName, firstName, email."
        cust = gets.chomp!.split()
        response = OrderClient.register lastName: cust[0], firstName: cust[1], email: cust[2]
        puts "status code #{response.code}"
        puts response.body
    when '2'
        puts "Create an item. Enter description, price, stockQty:"
        item = gets.chomp!.split()
        response = OrderClient.createItem description: item[0], price: item[1], stockQty: item[2]
        puts "status code #{response.code}"
        puts response.body
    when '3'
        puts "Make a purchase. Enter item ID and customer email:"
        data = gets.chomp!.split()
        response = OrderClient.newOrder itemId: data[0], email: data[1]
    when '4'
        puts "Enter ID or email of customer to lookup:"
        cust = gets.chomp!
        response = OrderClient.getCustomer(cust)
        puts "status code #{response[0]}"
        puts response[1]
    when '5'
        puts "Lookup item. Enter item ID:"
        id = gets.chomp!
        response = OrderClient.getItem(id)
        puts "status code #{response.code}"
        puts response.body
    when '6'
        puts "Retrieve order by ID. Enter ID: "
        id = gets.chomp!
        response = OrderClient.getOrder(id)
        puts "status code #{response.code}"
        puts response.body
    else puts "Invalid choice."
    end
end