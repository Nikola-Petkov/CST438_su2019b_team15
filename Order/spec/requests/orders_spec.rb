require 'rails_helper'

RSpec.describe "Orders", type: :request do
  
  before(:each) do
    # create database record for a customer
    #Order.create(itemId: 1, description: "some item", customerId: 1)
    #allow(Order).to receive(:create) { 1 }
  end
  
  describe "GET /orders?customerId=" do
    
    it 'get order information by ID' do
      item = double('item')
      customer = double('customer')
      allow(item).to receive(:id) {1}
      allow(customer).to receive(:email) {'jsmith@csumb.edu'}
      cr = Order.new [customer]
      expect(cr).to eq(2, 'jsmith@csumb.edu')
      
      headers = { "ACCEPT" => "application/json"}    # Rails 4
      get '/orders?customerId=1', headers: headers
      expect(response).to have_http_status(200)
      json_response = JSON.parse(response.body)
      p json_response
      #customer = json_response['customerId']
      #expect(customer).to eq 1
    end
    
    it 'get order information by email' do
      headers = { "ACCEPT" => "application/json"}    # Rails 4
      get '/orders?email=npetkov@csumb.edu', headers: headers
      expect(response).to have_http_status(200)
      #json_response = JSON.parse(response.body)
      #customer = json_response['customerId']
      #expect(customer).to eq 1
    end
    
    it 'get order by customer ID' do
      get '/orders?customerId=1', headers: headers
      expect(response).to have_http_status(200)
    end
  end
  
  describe "POST /customers" do
    
    it 'register a customer' do
      headers = { "CONTENT_TYPE" => "application/json" ,
                  "ACCEPT" => "application/json" }  # Rails 4
      customer = {'lastName' => 'Petkov',
                  'firstName' => 'Nikola',
                  'email' => 'nikolapetkov@sbcglobal.net' }
      post '/customers', :params => customer.to_json, :headers => headers
      expect(response).to have_http_status(201)
      customer_response = JSON.parse(response.body)
      expect(customer_response).to include customer
      
      customer = Customer.find_by(email: 'nikolapetkov@sbcglobal.net')
      expect(customer).to be_truthy
      expect(customer.email).to eq 'nikolapetkov@sbcglobal.net'
    end
    
    it 'register a duplicate should fail' do
      headers = { "CONTENT_TYPE" => "application/json" ,
                  "ACCEPT" => "application/json" }  # Rails 4
      customer = {'firstName' => 'Nikola',
                  'lastName' => 'Petkov',
                  'email' => 'npetkov@csumb.net' }
      post '/customers', :params => customer.to_json, :headers => headers
      expect(response).to have_http_status(201)
      customer_response = JSON.parse(response.body)
      expect(customer_response).to include customer
      post '/customers', :params => customer.to_json, :headers => headers
      expect(response).to have_http_status(400)
    end
    
    it 'register with missing fields should fail' do
      headers = { "CONTENT_TYPE" => "application/json" ,
                  "ACCEPT" => "application/json" }  # Rails 4
      customer = {'firstName' => 'Nikola'}
      post '/customers', :params => customer.to_json, :headers => headers
      expect(response).to have_http_status(400)
      #customer_response = JSON.parse(response.body)
      #expect(customer_response).to have_key('messages')
    end
  end
  
  describe 'PUT /customers/order' do
    
    it 'customer makes 4 purchases' do
      headers = { "CONTENT_TYPE" => "application/json" ,
                  "ACCEPT" => "application/json" }  # Rails 4
      
      order1 = { id: 1, customerId: 1, itemId: 1, price: 250.00, award: 0, total: 250.00 }
      put '/customers/order', :params => order1.to_json, :headers => headers
      expect(response).to have_http_status(204)
      
      get "/customers?id=1", headers: headers
      expect(response).to have_http_status(200)
      
      customer_response = JSON.parse(response.body)
      expect(customer_response['award']).to eq 0
      expect(customer_response['lastOrder']).to eq 250.00
      expect(customer_response['lastOrder2']).to eq 0
      expect(customer_response['lastOrder3']).to eq 0
      
      order2 = { id: 2, customerId: 1, itemId: 2, price: 120.00, award: 0, total: 120.00 }
      put '/customers/order', :params => order2.to_json, :headers => headers
      expect(response).to have_http_status(204)
      
      get "/customers?id=1", headers: headers
      expect(response).to have_http_status(200)
      customer_response = JSON.parse(response.body)
      expect(customer_response['award']).to eq 0
      expect(customer_response['lastOrder']).to eq 120.00
      expect(customer_response['lastOrder2']).to eq 250.00
      expect(customer_response['lastOrder3']).to eq 0
      
      order3 = { id: 3, customerId: 1, itemId: 3, price: 490.00, award: 0, total: 490.00 }
      put '/customers/order', :params => order3.to_json, :headers => headers
      expect(response).to have_http_status(204)
      
      get "/customers?id=1", headers: headers
      expect(response).to have_http_status(200)
      customer_response = JSON.parse(response.body)
      expect(customer_response['award']).to eq 28.67
      expect(customer_response['lastOrder']).to eq 490.00
      expect(customer_response['lastOrder2']).to eq 120.00
      expect(customer_response['lastOrder3']).to eq 250.00
      
      order4 = { id: 4, customerId: 1, itemId: 4, price: 200.00, award: 28.67, total: 171.33 }
      put '/customers/order', :params => order4.to_json, :headers => headers
      expect(response).to have_http_status(204)
      
      get "/customers?id=1", headers: headers
      expect(response).to have_http_status(200)
      customer_response = JSON.parse(response.body)
      expect(customer_response['award']).to eq 0
      expect(customer_response['lastOrder']).to eq 0
      expect(customer_response['lastOrder2']).to eq 0
      expect(customer_response['lastOrder3']).to eq 0
    end
  end
  
end



