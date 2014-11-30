#ALL API CONTROLLERS ARE CHILDREN OF THIS CONTROLLER
module Api  
  module V1
    class ApiController < ApplicationController
      before_filter :authenticate
      respond_to :json

      protected
      def authenticate
        @current_account = Account.find_by_parent_key(params[:parent_licence_key])
        
        if @current_account
          #Successfully found account
          @current_account.touch #Tracking purposes
        else
          render json: {success: false, message: 'Could not find your account'}, status: 401
        end
      end
    end
  end
end