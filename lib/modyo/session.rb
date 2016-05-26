module Modyo
  module Session
    extend ActiveSupport::Concern

    POLICY = 'CP="NOI ADM DEV PSAi COM NAV OUR OTRo STP IND DEM"'

    included do
      before_filter :set_p3p_headers
      before_filter :init_modyo_session
      before_filter :check_for_a_modyo_application

      helper_method :modyo_session
    end

    # Check that we're using an app named 'modyo_app' and it's of
    # class Modyo::App.
    #
    def check_for_a_modyo_application
      unless @modyo_app && @modyo_app.is_a?(Modyo::App)
        raise StandardError
      end
    end

    # Creates a new Modyo::App object.
    #
    def modyo_app(options = {})
      @modyo_app ||= Modyo::App.new(
          key: options[:key],
          secret: options[:secret],
          host: options[:host]
      )
    end

    # For the controller to answer whether there's a session or not.
    #
    def require_modyo_authentication
      return true if modyo_session
      session[:m_return] = request.url # Remember the URL of the intended resource
      authorize_with_modyo(@modyo_app)
    end

    protected

    def authorize_with_modyo(modyo_app)
      redirect_to modyo_app.authorize_url
    end

    def init_modyo_session
      raise StandardError if @modyo_app.nil?

      if params[:code]
        Rails.logger.debug '=========================================='
        begin
          session[:m_user] = modyo_app.modyo_user_session(params[:code])
        rescue Exception => ex
          flash[:error] = "Unauthorized Session #{ex.message}"
        end
      end
    end

    def modyo_session
      Rails.logger.debug 'modyo_session'
      if session[:m_user] && session[:m_user][:id] != 0
        return session[:m_user]
      end

      nil
    end

    def destroy_modyo_session!
      session[:m_user] = nil
    end

    def set_p3p_headers
      headers['P3P'] = 'CP="IDC DSP COR ADM DEVi TAIi PSA PSD IVAi IVDi CONi HIS OUR IND CNT"'
    end
  end
end
