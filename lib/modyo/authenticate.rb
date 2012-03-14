module Modyo
  module Authenticate

    module ClassMethods
      def authenticate_with_modyo
        if session[:user]
          true
        else
          session[:return_to] = request.url
          redirect_to '/modyo'
        end
      end
    end

    module InstanceMethods
      def authenticate_with_modyo
        if session[:user]
          true
        else
          session[:return_to] = request.url
          redirect_to '/modyo'
        end

      end
    end

  end
end
