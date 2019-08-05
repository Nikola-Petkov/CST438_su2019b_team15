class CustomersController < ApplicationController
  
  # GET /customers?id=:id
  # GET /customers?email=:email
  def get
    @id = params[:id]
    @email = params[:email]
    @customer = nil
    if !@id.nil?
      @customer = Customer.find_by(id: @id)
    elsif !@email.nil?
      @customer = Customer.find_by(email: @email)
    end
    
    if !@customer.nil?
      render json: @customer.to_json, status: 200
    else
      head 404
    end
  end
  
  # POST /customers
  def create
    @customer = Customer.new(customer_params)
    @customer.award = 0
    @customer.lastOrder = 0
    @customer.lastOrder2 = 0
    @customer.lastOrder3 = 0
    
    if @customer.save
      render json: @customer.to_json, status: 201
    else
      head 400
    end
  end
  
  # PUT /customers/order
  def processOrder
    @id = params[:customerId]
    @award = params[:award]
    @total = params[:total]
    @customer = Customer.find_by(id: @id)
    
    if @award == 0
      @customer.lastOrder3 = @customer.lastOrder2
      @customer.lastOrder2 = @customer.lastOrder
      @customer.lastOrder = @total
      if @customer.lastOrder != 0 and @customer.lastOrder2 != 0 and @customer.lastOrder3 != 0
        @customer.award = "%.2f" % (0.1 * (@customer.lastOrder3 + @customer.lastOrder2 + @customer.lastOrder) / 3.0)
      end
    else
      @customer.award = 0
      @customer.lastOrder = 0
      @customer.lastOrder2 = 0
      @customer.lastOrder3 = 0
    end
    
    if @customer.save
      head 204
    else
      head 400
    end
  end
  
  # Never trust parameters from the scary internet, only allow the white list through.
  def customer_params
    params.require(:customer).permit(:lastName, :firstName, :email)
  end
end