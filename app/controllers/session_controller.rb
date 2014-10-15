before '/*' do
	@logged_in = session[:id]
end

get '/' do
	erb :"session/index"
end

post '/login' do
	@user = User.find_or_create_by(phone: params[:phone])
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