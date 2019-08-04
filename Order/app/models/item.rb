class Item
    
    include HTTParty
    
    # default_options.update(verify: false) # Turn off SSL verification
    base_uri "http://localhost:8082"
    format :json
    
    def Item.getItemById(id)
        response = get "/items/#{id}", headers: { "ACCEPT" => "application/json" }
        status = response.code
        item = JSON.parse response.body, symbolize_names: true
        # return http status code and ruby hash of item data
        return status, item
    end
    
    def Item.putOrder(order)
        response = put "/items/order",
                    body: order.to_json,
                    headers: { "CONTENT_TYPE" => "application/json" }
        return response.code
    end
end