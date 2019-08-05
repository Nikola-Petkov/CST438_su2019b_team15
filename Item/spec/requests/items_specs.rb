require 'rails_helper'

RSpec.describe "Items", type: :request do
  
  before(:each) do 
    # create database record for a customer
    Item.create(description: 'Awesome toy', price: 1.0, stockQty: 1)
  end
  
  describe "GET /items" do
    
    it 'get item descriptionm by ID' do
      headers = { "ACCEPT" => "application/json"}    # Rails 4
      get '/items/?id=1', headers: headers
      expect(response).to have_http_status(200)
      json_response = JSON.parse(response.body)
      itemer = json_response['description']
      expect(itemer).to eq 'Awesome toy'
    end
    
    it 'get item by non-existent ID should fail' do
      get '/items?id=-1', headers: headers
      expect(response).to have_http_status(404)
    end
  end
end