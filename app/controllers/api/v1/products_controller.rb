module Api  
  module V1
    class ProductsController < ApiController
      #Retreive all licences for an account
      def index 
        @products = @current_account.products.includes(:sub_products)
        render json: @products
      end

      def show
        @product = Product.find(params[:id])
        render json: @product
      end
    end
  end
end