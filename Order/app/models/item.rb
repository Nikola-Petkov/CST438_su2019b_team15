class Item
    
    include HTTParty
    
    # default_options.update(verify: false) # Turn off SSL verification
    base_uri "http://localhost:8082"
    format :json
    
    def Item.getItemById(id)
        response = get "/items?id=#{id}", headers: { "ACCEPT" => "application/json" }
        status = response.code
        if status == 200
            item = JSON.parse response.body, symbolize_names: true
        else item = "Item not found."
        end
        # return http status code and ruby hash of item data
        return status, item
    end
    
    def Item.createItem(item)
        post '/items', body: item.to_json,   headers:{ 'Content-Type' => 'application/json', 'ACCEPT' => 'application/json' }
    end
    
    def Item.putOrder(order)
        response = put "/items/order",
                    body: order.to_json,
                    headers: { "CONTENT_TYPE" => "application/json" }
        return response.code
    end
end