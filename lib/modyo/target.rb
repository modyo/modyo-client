module Modyo
  class Target

    def self.consumer
      ::OAuth::Consumer.new(MODYO["key"], MODYO["secret"], :site => MODYO["site_url"])
    end

    def self.add_to_target(user, options = {})

      @access_token = ::OAuth::AccessToken.new(self.consumer, user.oauth_token, user.oauth_secret)
      response = @access_token.post("/api/targets/add_to_target", {:target_id => options[:target_id]})
      target_response = ::Nokogiri::XML(response.body)
      return target_response
    end

    def self.del_from_target(user, options = {})

      @access_token = ::OAuth::AccessToken.new(self.consumer, user.oauth_token, user.oauth_secret)
      response = @access_token.post("/api/targets/del_from_target", {:target_id => options[:target_id]})
      target_response = ::Nokogiri::XML(response.body)
      return target_response
    end

  end
end