module Modyo
  class App
    attr_reader :key
    attr_reader :secret
    attr_reader :host

    def initialize(options = {})
      @key    = options[:key]
      @secret = options[:secret]
      @host   = options[:host]
    end

    def authorize_url
      consumer.auth_code.authorize_url(redirect_uri: callback_url)
    end

    def get_token(code)
      @access_token ||= consumer.auth_code.get_token(code, redirect_uri: callback_url)
    end
    alias_method :token, :get_token

    def user_info(code)
      response = token(code).get("#{account_url}/api/v1/users/me")
      user_info = JSON.parse response.body
      user_info.symbolize_keys
    end

    def modyo_user_session(code)
      { token: get_token(code).token }.merge(user_info(code))
    end

    def consumer
      @consumer ||= ::OAuth2::Client.new(
          key,
          secret,
          authorize_url: '/oauth/authorize',
          token_url:     '/oauth/token',
          site:          account_url
      )
    end

    private

    def callback_url
      #"#{account_url}/session/callback"
      'http://fd6cc0f4.ngrok.io/sessions/callback'
      "http://fd6cc0f4.ngrok.io/#{@host}/sessions/callback"
    end

    def account_url
      "https://#{@host}.modyo.io"
    end
  end
end
