module Modyo
  module Session

    POLICY = 'CP="NOI ADM DEV PSAi COM NAV OUR OTRo STP IND DEM"'

    def self.included(base)
      base.extend(ClassMethods)

      base.class_eval do

        # Filters

        before_filter :set_p3p_headers
        before_filter :init_modyo_session


        # Helpers

        helper_method :link_to_modyo_profile
        helper_method :modyo_admin_profile_url
        helper_method :modyo_site_key
        helper_method :modyo_site_url
        helper_method :modyo_account_url
        helper_method :modyo_account_host
        helper_method :modyo_site_main_url
        helper_method :modyo_site_me_url
        helper_method :modyo_admin_main_url
        helper_method :modyo_session

      end
    end


    # Class Methods

    module ClassMethods
      def consumer

        #::OAuth2::Client.new(Rails.application.secrets.modyo_client_id, Rails.application.secrets.modyo_client_secret, :site => Rails.application.secrets.modyo_account_url)

        ::OAuth2::Client.new(MODYO["key"], MODYO["secret"], :site => MODYO["account_url"])
      end
    end


    # Instance Methods

    def require_modyo_authentication

      Rails.logger.debug "[Modyo::Session] Modyo Authentication filter required"

      if modyo_session

        Rails.logger.debug "[Modyo::Session] Session found!"
        return true
      end

      session[:m_return] = request.url # Remember the URL of the intended resource

      Rails.logger.debug "[Modyo::Session] Modyo Session not found. Starting the authorization process..."

      authorize_with_modyo
    end


    protected

    def authorize_with_modyo

      @access_token = self.class.consumer.client_credentials.get_token
      session[:m_token] = @access_token.token

      Rails.logger.debug "[Modyo::Session] Starting the login process"
      Rails.logger.debug "[Modyo::Session] Token: #{session[:m_token]}"

      Rails.logger.debug "[Modyo::Session] Redirect to : #{@access_token.authorize_url}"
      redirect_to @access_token.authorize_url
    end

    def init_modyo_session

      Rails.logger.debug "[Modyo::Session] Entering in the Modyo session initialization..."
      Rails.logger.debug "[Modyo::Session] Stored Token: #{session[:m_token]}"

      if session[:m_token]
        begin

          @access_token = self.class.consumer.client_credentials.get_token

          profile_api_url = "#{MODYO["account_url"]}api/v1/users/me"
          Rails.logger.debug "[Modyo::Session] Requesting for Modyo user profile info from #{profile_api_url}"
          response = @access_token.get(profile_api_url)

          Rails.logger.debug "[Modyo::Session] Modyo Response Body #{response.body}"

          user_info = JSON.parse response.body

          session[:m_user] = {:token => @access_token.token}.merge!(user_info)

        rescue Exception => ex

          flash[:error] = "Unauthorized Session #{ex.message}"
          #redirect_to root_path

        ensure
          clean_modyo_tokens!
        end

      end
    end

    def set_p3p_headers
      headers['P3P'] = 'CP="IDC DSP COR ADM DEVi TAIi PSA PSD IVAi IVDi CONi HIS OUR IND CNT"'

    end

    def destroy_modyo_session!
      session[:m_user] = nil
    end

    def clean_modyo_tokens!
      session[:m_token] = nil
    end

    def link_to_modyo_profile(user, options = {})
      "<a href=\"#{modyo_admin_profile_url(user)}\" class=\"parent\">#{(options[:text] || user.name)}</a>".html_safe
    end

    # Parameters

    def modyo_site_key
      MODYO['site_key']
    end

    def modyo_site_url
      MODYO['site_url']
    end

    def modyo_account_url
      MODYO['account_url']
    end

    def modyo_account_host
      MODYO['account_host']
    end

    def modyo_site_main_url
      "#{modyo_site_url}/apps/#{MODYO['app_namespace']}"
    end

    def modyo_site_me_url
      "#{modyo_site_url}/me/#{MODYO['app_namespace']}"
    end

    def modyo_admin_main_url
      "#{modyo_account_url}/#{modyo_site_key}/admin/apps/custom/#{MODYO['app_namespace']}"
    end

    def modyo_admin_profile_url(user)
      "#{modyo_account_url}/profile"
    end

    def modyo_session

      Rails.logger.debug "[Modyo::Session] Getting the modyo session: #{session[:m_user].inspect}"

      if session[:m_user] && session[:m_user][:id] != 0

        Rails.logger.debug "[Modyo::Session] session found for modyo_id: #{session[:m_user][:id]}"

        return session[:m_user]
      end

      Rails.logger.debug "[Modyo::Session] session not found :("

      nil
    end

  end

end
