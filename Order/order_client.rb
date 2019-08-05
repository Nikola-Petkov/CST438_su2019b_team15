require 'httparty'

class OrderClient
    include HTTParty
    
    base_uri "http://localhost:8080"
    format :json
    
    def self.register(cust)
        post '/customers', body: cust.to_json,
            headers: { 'Content-Type' => 'application/json', 'ACCEPT' => 'application/json' }
    end
    
    def self.getId(id)
        get "/customers?id=#{id}"
    end
    
    def self.getEmail(email)
        get "/customers?email=#{email}"
    end
    
    def self.searchCust(id)
        get "/orders?customerId=#{id}"
    end
    
end

while true
    puts "What do you want to do: customer lookup, register, id, email, quit."
    input = gets.chomp!
    case input
    when 'quit'
        puts "Goodbye."
        break
    when 'item'
        puts "Enter ID or email of customer to lookup:"
        cust = gets.chomp!.split()
        response = OrderClient.searchCust(cust)
        puts "status code #{response.code}"
        puts response.body
    when 'register'
        puts "Register a new customer. Enter lastName, firstName, email."
        data = gets.chomp!.split()
        response = OrderClient.register lastName: data[0], firstName: data[1], email: data[2]
        puts "status code #{response.code}"
        puts response.body
    when 'email'
        puts "Retrieve customer data by email. Enter email: "
        email = gets.chomp!
        response = OrderClient.getEmail(email)
        puts "status code #{response.code}"
        puts response.body
    when 'id'
        puts "Retrieve customer data by ID. Enter ID: "
        id = gets.chomp!
        response = OrderClient.getId(id)
        puts "status code #{response.code}"
        puts response.body
    else puts "Invalid choice."
    end
end