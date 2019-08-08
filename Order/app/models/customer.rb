class Customer
    
    include HTTParty
    
    # default_options.update(verify: false) # Turn off SSL verification
    base_uri "http://localhost:8081"
    format :json
    
    def self.register(cust)
        post '/customers', body: cust.to_json,   headers:{ 'Content-Type' => 'application/json', 'ACCEPT' => 'application/json' }
    end
    
    def Customer.getCustomer(cust)
        if cust.include? '@' 
            response = get "/customers?email=#{cust}", headers: { "ACCEPT" => "application/json" }
        else
            response = get "/customers?id=#{cust}", headers: { "ACCEPT" => "application/json" }
        end
        status = response.code
        if status == 200
            customer = JSON.parse response.body, symbolize_names: true
        else customer = "Customer not found."
        end
        # return http status code and ruby hash of customer data
        return status, customer
    end
    
    def Customer.putOrder(order)
        response = put "/customers/order",
                    body: order.to_json,
                    headers: { "CONTENT_TYPE" => "application/json" }
        return response.code
    end
end