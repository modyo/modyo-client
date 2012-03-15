# CURRENT FILE :: app/controllers/team_page/team_controller.rb

module Modyo
  class ModyoController < ::ApplicationController

    def self.consumer
      ::OAuth::Consumer.new(MODYO["key"], MODYO["secret"], :site => MODYO["site_url"])
    end

    # Actions

    def create

      @request_token = ModyoController.consumer.get_request_token
      session[:request_token_token] = @request_token.token
      session[:request_token_secret] = @request_token.secret

      redirect_to @request_token.authorize_url
    end

    def callback

      @request_token = ::OAuth::RequestToken.new(ModyoController.consumer, session[:request_token_token], session[:request_token_secret])
      @access_token = @request_token.get_access_token(:oauth_verifier => params[:oauth_verifier])

      response = @access_token.get("/api/base/profile")

      user_info = ::Nokogiri::XML(response.body)

      session[:user] = {:modyo_id => user_info.xpath('/user/uid').text().to_i, :token => @access_token.token,
                        :secret => @access_token.secret, :full_name => user_info.xpath('/user/full_name').text(),
                        :nickname => user_info.xpath('/user/nickname').text(), :image_url => user_info.xpath('/user/avatar').text(),
                        :birthday => user_info.xpath('/user/birthday').text(), :sex => user_info.xpath('/user/sex').text(),
                        :country => user_info.xpath('/user/country').text(), :lang => user_info.xpath('/user/lang').text(), :email => user_info.xpath('/user/email').text()}

      redirect_to '/login'
    end

    def destroy
      session[:user] = nil

      redirect_to_back
    end


    # Helper methods

    helper_method :link_to_modyo_profile

    def link_to_modyo_profile(user, options = {})

      link_to (options[:text] || user.name), modyo_profile_path(user), :class => 'parent'
    end

    helper_method :modyo_profile_path

    def modyo_profile_path(user)
      "/#{modyo_site_key}/admin/people/members/show?membership_id=#{user.modyo_id}"
    end

    # Parameters

    helper_method :modyo_site_key

    def modyo_site_key
      MODYO['site_key']
    end


    helper_method :modyo_site_url

    def modyo_site_url
      MODYO['site_url']
    end


    helper_method :modyo_account_url

    def modyo_account_url
      MODYO['account_url']
    end


    helper_method :modyo_account_host

    def modyo_account_host
      MODYO['account_host']
    end


    helper_method :modyo_site_main_url

    def modyo_site_main_url
      "#{modyo_site_url}/apps/#{MODYO['canvas_namespace']}"
    end


    helper_method :modyo_site_me_url

    def modyo_site_me_url
      "#{modyo_site_url}/me/#{MODYO['canvas_namespace']}"
    end


    helper_method :modyo_admin_main_url

    def modyo_admin_main_url
      "#{modyo_account_url}/#{modyo_site_key}/admin/apps/#{MODYO['canvas_namespace']}"
    end


    protected

    def redirect_to_back(redirect_opts = nil)
      redirect_to redirect_to_back_url(redirect_opts)
    end

    def redirect_to_back_url(redirect_opts = nil)
      redirect_opts ||= {:controller => '/'}
      request.env["HTTP_REFERER"] ? (request.env["HTTP_REFERER"]) : (redirect_opts)
    end

  end

end
