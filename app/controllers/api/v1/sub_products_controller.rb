module Api  
  module V1
    class SubProductsController < ApiController
      #Retreive all licences for an account
      def index 
        @sub_products = @current_account.sub_products
        render json: @sub_products
      end

      def show
        begin
          @sub_product = SubProduct.find(params[:id])
          render json: @sub_product
        rescue
          render json: {success: false, message: "Couldn\'t find a sub product with id: #{params[:id]}"}, status: 401
        end
      end
    end
  end
end