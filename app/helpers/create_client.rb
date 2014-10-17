helpers do
	def create_client
		account_sid = ENV['TWILIO_SID']
		auth_token = ENV['TWILIO_TOKEN']
		return Twilio::REST::Client.new(account_sid, auth_token)
	end
end
