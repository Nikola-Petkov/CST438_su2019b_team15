require 'httparty'

class OrderClient
    include HTTParty
    
    base_uri "http://localhost:8080"
    format :json
    
    def self.register(cust)
        post '/customers', body: cust.to_json,
            headers: { 'Content-Type' => 'application/json', 'ACCEPT' => 'application/json' }
    end
    
    def self.createItem(data)
        post '/items', body: data.to_json,
            headers: { 'Content-Type' => 'application/json', 'ACCEPT' => 'application/json' }
    end
    
    def self.getCustomer(cust)
        if !cust.include? '@' 
            get "/orders?customerId=#{cust}"
        else
            get "/orders?email=#{cust}"
        end
    end
    
    def self.getOrder(id)
        get "/orders/#{id}"
    end
    
    def self.getItem(id)
        get "/items/#{id}"
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
    when '4'
        puts "Enter ID or email of customer to lookup:"
        cust = gets.chomp!.split()
        response = OrderClient.getCustomer(cust)
        puts "status code #{response.code}"
        puts response.body
    when '1'
        puts "Register a new customer. Enter lastName, firstName, email."
        data = gets.chomp!.split()
        response = OrderClient.register lastName: data[0], firstName: data[1], email: data[2]
        puts "status code #{response.code}"
        puts response.body
    when '2'
        puts "Create an item. Enter description, price, stockQty:"
        data = gets.chomp!.split()
        response = OrderClient.createItem description: data[0], price: data[1], stockQty: data[2]
        puts "status code #{response.code}"
        puts response.body
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
    when '3'
        puts "Make a purchase. Enter item ID and customer email:"
        data = gets.chomp!.split()
        response = OrderClient.newOrder itemId: data[0], email: data[1]
    else puts "Invalid choice."
    end
end