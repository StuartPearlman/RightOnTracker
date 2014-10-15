post '/users/:user_id/trains/create' do
	if @user.trains.length < 3
		day_string = ''
		params[:days].each_value do |value|
			day_string += value
		end

		@train = Train.create(stop: params[:stop], line: params[:line], user_id: params[:user_id], time: params[:time], days: day_string)

		SendTimes.perform_at(@train.time, @train.id)
		
		erb :"user/_stops_partial", :layout => false
	else
		halt 400, "Limit of three train stops exceeded. Please delete some train stops to continue."
	end
end

post '/users/:user_id/trains/:train_id' do
	Train.destroy(params[:train_id])
	redirect "users/#{params[:user_id]}"
end
