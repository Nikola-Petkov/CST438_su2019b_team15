require 'httparty'

class ItemClient
    include HTTParty
    
    base_uri "http://localhost:8080"
    format :json
    
    def self.register(item)
        post '/items', body: item.to_json,
            headers: { 'Content-Type' => 'application/json', 'ACCEPT' => 'application/json' }
    end
    
    def self.getId(id)
        get "/items?id=#{id}"
    end

    
end

while true
    puts "What do you want to do: create, id, email, quit."
    input = gets.chomp!
    case input
    when 'quit'
        puts "Goodbye."
        break
    when 'create'
        puts "Enter item description, price, stockQty."
        data = gets.chomp!.split()
        response = ItemClient.register description: data[0], price: data[1], stockQty: data[2]
        puts "status code #{response.code}"
        puts response.body
    when 'email'
        puts "Retrieve customer data by email. Enter email: "
        email = gets.chomp!
        response = CustomerClient.getEmail(email)
        puts "status code #{response.code}"
        puts response.body
    when 'id'
        puts "Retrieve customer data by ID. Enter ID: "
        id = gets.chomp!
        response = CustomerClient.getId(id)
        puts "status code #{response.code}"
        puts response.body
    else puts "Invalid choice."
    end
end