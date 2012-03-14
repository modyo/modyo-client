module Modyo
  class Mailer
   def self.mail(user, options = {})

     @access_token = ::OAuth::AccessToken.new(Modyo::ModyoController.consumer, user.oauth_token, user.oauth_secret)
     response = @access_token.post("/api/base/mailer", {:recipient => user.modyo_id, :message => options[:message], :subjet => options[:subjet]})
     user_info = ::Nokogiri::XML(response.body)
     return user_info
   end

  end
  end
