class ItemsController < ApplicationController
    
    #<-------All GET methods
    #GET /items?id=:id
    def get
        @id = params[:id] #collect input
        @item = nil
        
        #check to make sure the id isn't null
        if !@id.nil?
            @item = Item.find_by(id: @id)
        end
        
        #check to make sure the item isn't null
        if !@item.nil?
          render json: @item.to_json, status: 200
        else
          head 404
        end
    end
    
    #<-------All POST methods
    #POST /items
    def create
        # defined object to receive strict item_params including :description, :price, :stockQty ; else return 400
        @item = Item.new(item_params)
        
        if @item.save
          render json: @item.to_json, status: 201
        else
          head 400
        end
    end
    
    #<-------All PUT methods
    #PUT /items/order
    #PUT /items
    def processItemsOrder
        @id = params[:itemID]
        @description = params[:description]
        @price = params[:price]
        @award = params[:award]
        @item = Item.find_by(id: @id)
        
        if @item.save
          head 204
        else
          # test
          render json: @item.to_json, status: 400
          # originally
          #head 400
        end
    end
    
    #<-------Validation methods
    #Define custom method for receiving discrete member instantiation method, is used in methods above
    def item_params
        params.require(:item).permit(:description, :price, :stockQty)
        #validates :price, presence: true
        #validates :description, presence: true
        #validates :stockQty, presence: true
    end
    
end
