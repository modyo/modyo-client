module Modyo
  class Mailer


    def self.send_email(user, options = {})

      @access_token = ::OAuth::AccessToken.new(::OAuth::Consumer.new(MODYO["key"], MODYO["secret"], :site => MODYO["site_url"]), user.oauth_token, user.oauth_secret)
      response = @access_token.post("/api/mailer", {:recipient => user.modyo_id, :message => options[:message], :subject => options[:subject]})
      user_info = ::Nokogiri::XML(response.body)
      return user_info
    end

  end
end