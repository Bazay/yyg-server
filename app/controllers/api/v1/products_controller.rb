module Api  
  module V1
    class ProductsController < ApiController
      #Retreive all licences for an account
      def index 
        @products = @current_account.products
        render json: @products
      end

      def show
        begin
          @product = Product.find(params[:id])
          render json: @product
        rescue
          render json: {success: false, message: "Couldn\'t find a product with id: #{params[:id]}"}, status: 401
        end
      end
    end
  end
end