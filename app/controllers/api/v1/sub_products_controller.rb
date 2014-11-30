module Api  
  module V1
    class SubProductsController < ApiController
      #Retreive all licences for an account
      def index 
        @sub_products = @current_account.sub_products
        render json: @sub_products
      end

      def show
        @sub_product = SubProduct.find(params[:id])
        render json: @sub_product
      end
    end
  end
end