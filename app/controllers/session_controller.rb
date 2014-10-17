configure do
  set :show_exceptions, false
end

before '/*' do
	@logged_in = session[:id] && session[:confirmed]
end

get '/' do
	erb :"session/index"
end

get '/notice' do
	erb :"session/notice"
end

post '/login' do
	@user = User.find_or_create_by(phone: params[:phone])
	if Time.now - @user.created_at < 2 
		pin = rand.to_s.reverse
		pin = pin[0..3]
		@user.password = pin
		@user.save!
	end
	session[:id] = @user.id
	redirect "/users/#{@user.id}/confirm"
end

get '/login' do
	erb :"session/login"
end

get '/logout' do
	session.destroy
	redirect '/'
end

not_found do
  erb :"error"
end

error do
	@error = env['sinatra.error']
	erb :"error"
end
