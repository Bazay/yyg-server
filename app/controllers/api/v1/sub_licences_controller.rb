module Api  
  module V1
    class SubLicencesController < ApiController
      #Retreive all licences for an account
      def index 
        @sub_licences = @current_account.sub_licences
        render json: @sub_licences
      end
    end
  end
end