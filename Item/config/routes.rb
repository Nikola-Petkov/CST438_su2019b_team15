Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  #root 'customers#index'
  #resources :customers
  get '/customers' => 'customers#get'
  post '/customers' => 'customers#create'
  put '/customers/order' => 'customers#processOrder'
end
