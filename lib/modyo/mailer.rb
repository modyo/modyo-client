module Modyo
  class Mailer
    def self.mail(user, options = {})

      @access_token = ::OAuth::AccessToken.new(Modyo::SessionController.consumer, user.oauth_token, user.oauth_secret)
      response = @access_token.post("/api/mailer", {:recipient => user.modyo_id, :message => options[:message], :subjet => options[:subjet]})
      user_info = ::Nokogiri::XML(response.body)
      return user_info
    end

  end
end
