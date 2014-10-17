before '/users/:user_id/*' do
	@user = User.find(params[:user_id])
	redirect '/login' unless @user.logged_in?(session)
end

get '/users/:user_id' do
	@user = User.find(params[:user_id])
	redirect '/login' unless @user.logged_in?(session) && session[:confirmed]
	erb :"user/profile"
end

get '/users/:user_id/confirm' do
	erb :"user/confirm"
end

post '/users/:user_id/confirm' do
	if @user.password == params[:pin]
		session[:confirmed] = true
		halt 200, "/users/#{@user.id}"
	else
		halt 400, "Pin is incorrect."
	end
end

post '/users/:user_id/code' do
	pin = (rand * 10000).floor.to_s
	@user.password = pin
	@user.save!

	@client = create_client
	@client.account.messages.create(
		:body => "Message from RightOnTracker:\nYour pin is #{pin}.",
		:to => "+1#{@user.phone}",
	:from => ENV['TWILIO_NUMBER'])

	halt 200, "Pin sent!"
end

post '/users/:user_id/delete' do
	User.destroy(params[:user_id])
	session.destroy
	redirect '/'
end
