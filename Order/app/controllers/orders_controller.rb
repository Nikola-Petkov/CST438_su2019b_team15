class OrdersController < ApplicationController
    # GET /orders
    # search by customerId or email
    def search
	    customerId = params['customerId']
	    email = params['email']
	    if !customerId.nil?
	    	orders = Order.where(customerId: customerId)
	    else			# If email is blank, find customer ID by email lookup.
	    	status, customer = Customer.getCustomer(email)
	    	orders = Order.where(customerId: customer[:id])
	    end
	    render json: orders, status: 200
    end
    
    # GET /orders/:id
    # search by order id
    def searchByOrder
    	orderId = params['id']
	    order = Order.where(id: orderId)
	    render json: order, status: 200
	end
    
    # POST /orders
    # POST /orders.json
    def create
	    @order = Order.new
	    code, customer = Customer.getCustomer(params[:email])
	    
	    if code != 200
		    render json: { error: "Customer email not found. #{params[:email]}" }, status: 400
		    return
	    end
	    
	    code, item = Item.getItemById(params[:itemId])
	    if code != 200
		    render json: { error: "Item id not found. #{params[:itemId]}" }, status: 400
		    return
	    end
	    
	    if item['stockQty'] <= 0
		    render json: { error: "Item is out of stock."}, status: 400
		    return
	    end
	    
	    @order.itemId = item['id']
	    @order.description = item['description']
	    @order.customerId = customer['id']
	    @order.price = item['price']
	    @order.award = customer['award']
	    @order.total = @order.price - @order.award
	    
	    if @order.save
    		# put order to customer and item subsystem to do their updates
		    code = Customer.putOrder(@order)
		    code = Item.putOrder(@order)
		    render json: @order, status: 201
	    else
    		render json: @order.errors, status: 400
    	end
    end
end