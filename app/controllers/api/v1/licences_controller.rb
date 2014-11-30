module Api  
  module V1
    class LicencesController < ApiController
      #Retreive all licences for an account
      def index 
        @licences = @current_account.licences
        render json: @licences
      end
    end
  end
end