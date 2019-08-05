Rails.application.routes.draw do
  get '/items' => 'items#get'
  post '/items' => 'items#create'
  put '/items/order' => 'items#processItemsOrder'
  put '/items' => 'items#processItemsOrder'
end
