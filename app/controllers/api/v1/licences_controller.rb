module Api  
  module V1
    class LicencesController < ApiController
      #Retreive all licences for an account
      def index 
        @licences = @current_account.licences
        render json: @licences
      end

      def sub_licences
        @sub_licences = @account.sub_licences
        render json: @sub_licences
      end

      def product_licences
        @product_licences = @account.sub_licences
        render json: @product_licences
      end

      def sub_product_licences
        @sub_product_licences
        render json: @sub_product_licences
      end
    end
  end
end