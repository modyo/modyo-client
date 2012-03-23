module Modyo
  class Mailer
    def self.mail(user, options = {})

      @access_token = ::OAuth::AccessToken.new(Modyo::Session.consumer, user.oauth_token, user.oauth_secret)
      response = @access_token.post("/api/mailer", {:recipient => user.modyo_id, :message => options[:message], :subject => options[:subject]})
      user_info = ::Nokogiri::XML(response.body)
      return user_info
    end

  end
end