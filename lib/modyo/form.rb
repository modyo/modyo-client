module Modyo
  class Form

    def self.consumer
      ::OAuth::Consumer.new(MODYO["key"], MODYO["secret"], :site => MODYO["site_url"])
    end

    def self.get_response(user, options = {})

      @access_token = ::OAuth::AccessToken.new(self.consumer, user.oauth_token, user.oauth_secret)
      response = @access_token.post("/api/form/get_response", { :form_id => options[:form_id] })
      response_body = ::Nokogiri::XML(response.body)
      return response_body
    end

  end
end