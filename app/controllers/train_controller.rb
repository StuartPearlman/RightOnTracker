post '/users/:user_id/trains/create' do
	if @user.trains.length < 3
		day_string = ''
		
		params[:days].each_value do |value|
			day_string += value
		end

		@train = Train.create(stop: params[:stop], line: params[:line], user_id: params[:user_id], time: params[:time].to_time, days: day_string)

		if Time.now > @train.time
			@train.time += (60*60*24) #reschedule times from the past to the future so they are not run instantly
			@train.save!
		end

		SendTimes.perform_at(@train.time, @train.id)

		halt 200, "Stop added!"
	else
		halt 400, "Limit of three train stops exceeded!"
	end
end

post '/users/:user_id/trains/:train_id' do
	Train.destroy(params[:train_id])
	halt 200, "Stop removed!"
end

get '/users/:user_id/stops' do 
	content_type 'text/javascript'
	erb :"user/_stops_partial", :layout => false
end

