require 'rails_helper'

RSpec.describe "Orders", type: :request do
  
  before(:each) do
    # create database record for a customer
    Order.create(id: 1, itemId: 1, description: "some item", customerId: 1, price: 9.95, award: 0, total: 9.95)
    Order.create(id: 2, itemId: 2, description: "another item", customerId: 1, price: 13.50, award: 0, total: 23.45)
    #allow(Order).to receive(:create) { 1 }
  end
  
  describe "GET /orders" do
    
    it 'get order information by customer ID' do
      get '/orders?customerId=1', headers: {"CONTENT_TYPE" => "application/json", "ACCEPT" => "application/json"}
      expect(response).to have_http_status(200)
      json_response = JSON.parse(response.body)
      expect(json_response[0]['id']).to eq 1
      customer = json_response[0]['customerId']
      expect(customer).to eq 1
    end
    
    it 'get order information by customer email' do
      expect(Customer).to receive(:getCustomer).with('jsmith@csumb.edu') do
        [ 200, { id: 1, award: 0 } ]
      end
      get '/orders?email=jsmith@csumb.edu', headers: {"CONTENT_TYPE" => "application/json", "ACCEPT" => "application/json"}
      expect(response).to have_http_status(200)
      json_response = JSON.parse(response.body)
      expect(json_response.size).to eq 2
      expect(json_response[1]['total']).to eq 23.45
    end
    
    it 'get order information by order ID' do
      get '/orders/1', headers: {"CONTENT_TYPE" => "application/json", "ACCEPT" => "application/json"}
      expect(response).to have_http_status(200)
      json_response = JSON.parse(response.body)
      expect(json_response[0]['id']).to eq 1
    end
  end
  
  describe "POST /orders" do
    
    it "customer makes a purchase" do
      order = { itemId: 2, email: 'np@csumb.edu' }
      headers = {"CONTENT_TYPE" => "application/json",
                 "ACCEPT" => "application/json"}    
      
      expect(Customer).to receive(:getCustomer).with('np@csumb.edu') do
        [ 200, {'id' => 1, 'award' => 0 } ]
      end
      
      expect(Item).to receive(:getItemById).with(2) do
        [ 200, { 'id' => 2, 'description' => 'another item',
                 'price'=> 13.50, 'stockQty'=> 2 } ]
      end
      
      allow(Customer).to receive(:putOrder) do |order|
        expect(order.customerId).to eq 1
        201
      end 
      
      allow(Item).to receive(:putOrder) do |order|
        expect(order.itemId).to eq 2
        201
      end
      
      post '/orders', params: order.to_json, headers: headers
      
      expect(response).to have_http_status(201)
      order_json = JSON.parse(response.body)
      expect(order_json).to include('itemId' => 2,
                                    'description' => 'another item',
                                    'customerId' => 1,
                                    'price' => 13.50,
                                    'award' => 0,
                                    'total' => 13.500)
    
    end
  end
end