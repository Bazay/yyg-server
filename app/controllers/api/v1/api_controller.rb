#ALL API CONTROLLERS ARE CHILDREN OF THIS CONTROLLER
module Api  
  module V1
    class ApiController < ApplicationController
      before_filter :set_account#, :authenticate, :unless => :authenticate_exceptions
      respond_to :json

      # protected
      # def authenticate
      #   @current_account = Account.find_by_authentication_token(params[:authentication_token])
            
      #   if @current_account
      #     #Successfully found account
      #     @current_account.touch #Track latest activity...
      #   else
      #     render json: {success: false, message: 'Invalid authentication token'}, status: 401
      #   end
      # end

      def set_account
        @current_account = Account.find_by_parent_key(params[:key])

        if @current_account
          @current_account.touch
        else
          render json: {success: false, message: 'Key does not match any Accounts'}, status: 401  
        end
      end

    end
  end
end