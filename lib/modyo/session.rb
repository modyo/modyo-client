module Modyo
  module Session

    def self.included(base)
      base.extend(ClassMethods)

      base.class_eval do

        # Filters

        before_filter :init_modyo_session


        # Helpers

        helper_method :link_to_modyo_profile
        helper_method :modyo_profile_path
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
        ::OAuth::Consumer.new(MODYO["key"], MODYO["secret"], :site => MODYO["site_url"])
      end
    end


    # Instance Methods

    def require_modyo_authentication
      if modyo_session
        true
      else
        session[:m_return] = request.url

        authorize_with_modyo
      end
    end


    protected

    def authorize_with_modyo

      @request_token = self.class.consumer.get_request_token
      session[:m_token] = @request_token.token
      session[:m_secret] = @request_token.secret

      redirect_to @request_token.authorize_url
    end

    def init_modyo_session

      if session[:m_token] && session[:m_secret]

        @request_token = ::OAuth::RequestToken.new(self.class.consumer, session[:m_token], session[:m_secret])
        @access_token = @request_token.get_access_token(:oauth_verifier => params[:oauth_verifier])

        response = @access_token.get("/api/profile")

        user_info = ::Nokogiri::XML(response.body)

        session[:m_user] = {:modyo_id => user_info.xpath('/user/uid').text().to_i,
                            :token => @access_token.token,
                            :secret => @access_token.secret,
                            :full_name => user_info.xpath('/user/full_name').text(),
                            :nickname => user_info.xpath('/user/nickname').text(),
                            :image_url => user_info.xpath('/user/avatar').text(),
                            :birthday => user_info.xpath('/user/birthday').text(),
                            :sex => user_info.xpath('/user/sex').text(),
                            :country => user_info.xpath('/user/country').text(),
                            :lang => user_info.xpath('/user/lang').text(),
                            :email => user_info.xpath('/user/email').text(),
                            :is_owner => user_info.xpath('/user/is_owner').text(),
                            :is_admin => user_info.xpath('/user/is_admin').text(),
                            :has_permissions => user_info.xpath('/user/has_permissions').text(),
                            :access_list => user_info.xpath('/user/access_list').text(), }

        clean_modyo_tokens!
      end
    end

    def destroy_modyo_session!
      session[:m_user] = nil
    end

    def clean_modyo_tokens!
      session[:m_token] = nil
      session[:m_secret] = nil
    end

    def link_to_modyo_profile(user, options = {})

      link_to (options[:text] || user.name), modyo_profile_path(user), :class => 'parent'
    end

    def modyo_profile_path(user)
      "/#{modyo_site_key}/admin/people/members/show?membership_id=#{user.modyo_id}"
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

    def modyo_session
      session[:m_user]
    end

  end

end
