require 'sidekiq'
require 'twilio-ruby'
require 'net/http'
require 'nokogiri'

class SendTimes
	include Sidekiq::Worker

	def perform(train_id)
		@train = Train.find(train_id)
		
		if @train && @train.days.include?(Time.now.wday.to_s)
			train_times = parse_arrivals(@train.stop, stops[@train.stop])
			phone = User.find(@train.user_id).phone
			# send_message(train_times, phone)
			print "I AM RUNNING ALL THE TIME!!!!!!!!!!!"
		end

		if @train
			SendTimes.perform_at(@train.time, @train.id)
		end
	end

	def parse_arrivals(stop_name, stop_id)
		train_times = "Your train times for #{stop_name} are:" + "\n"
		url = "http://lapi.transitchicago.com/api/1.0/ttarrivals.aspx?key=#{ENV['CTA_KEY']}&stpid=#{stop_id}"

		xml_data = Net::HTTP.get_response(URI.parse(url)).body

		doc = Nokogiri::XML(xml_data)

		doc.xpath('//eta').each do |arrival|
			time = arrival.at_xpath('arrT').content
			time = time[9..10]+time[12..13]
			time = format_time(time.to_i)
			train_times += time + "\n"
		end
		return train_times
	end

	def send_message(train_times, phone)
		client = create_client
		message = client.account.messages.create(
			:body => "#{train_times}\nSent by RightOnTracker, a Stu Pearlman app.",
			:to => "+1#{phone}",
		:from => ENV['TWILIO_NUMBER'])
	end

	def format_time(time)
		t = (time <= 1200)? time : time - 1200
		return (t.to_s.size == 3)? t.to_s.insert(1,":") : t.to_s.insert(2,":")
	end

	def create_client
		account_sid = ENV['TWILIO_SID']
		auth_token = ENV['TWILIO_TOKEN']
		return Twilio::REST::Client.new(account_sid, auth_token)
	end

	def stops
		stops = {}
		stops["18th (54th/Cermak-bound)"] = 30162
		stops["18th (Loop-bound)"] = 30161
		stops["35th/Archer (Loop-bound)"] = 30022
		stops["35th/Archer (Midway-bound)"] = 30023
		stops["35-Bronzeville-IIT (63rd-bound)"] = 30214
		stops["35-Bronzeville-IIT (Harlem-bound)"] = 30213
		stops["43rd (63rd-bound)"] = 30246
		stops["43rd (Harlem-bound)"] = 30245
		stops["47th (63rd-bound) Elevated (63rd-bound)"] = 30210
		stops["47th (SB) Elevated (Harlem-bound)"] = 30209
		stops["47th-Dan Ryan (95th-bound)"] = 30238
		stops["47th-Dan Ryan (Howard-bound)"] = 30237
		stops["51st (63rd-bound)"] = 30025
		stops["51st (Harlem-bound)"] = 30024
		stops["54th/Cermak (Loop-bound)"] = 30113
		stops["54th/Cermak (Terminal arrival)"] = 30114
		stops["63rd-Dan Ryan (95th-bound)"] = 30178
		stops["63rd-Dan Ryan (Howard-bound)"] = 30177
		stops["69th (95th-bound)"] = 30192
		stops["69th (Howard-bound)"] = 30191
		stops["79th (95th-bound)"] = 30047
		stops["79th (Howard-bound)"] = 30046
		stops["87th (95th-bound)"] = 30276
		stops["87th (Howard-bound)"] = 30275
		stops["95th/Dan Ryan (95th-bound)"] = 30089
		stops["95th/Dan Ryan (Howard-bound)"] = 30088
		stops["Adams/Wabash (Inner Loop)"] = 30132
		stops["Adams/Wabash (Outer Loop)"] = 30131
		stops["Addison (O'Hare Branch) (Forest Pk-bound)"] = 30240
		stops["Addison (O'Hare Branch) (O'Hare-bound)"] = 30239
		stops["Addison (Kimball-bound)"] = 30277
		stops["Addison (Loop-bound)"] = 30278
		stops["Addison (95th-bound)"] = 30274
		stops["Addison (Howard-bound)"] = 30273
		stops["Argyle (95th-bound)"] = 30230
		stops["Argyle (Howard-bound)"] = 30229
		stops["Armitage (Kimball-Linden-bound)"] = 30127
		stops["Armitage (Loop-bound)"] = 30128
		stops["Ashland (Loop-bound)"] = 30205
		stops["Ashland (Midway-bound)"] = 30206
		stops["Ashland (Harlem-54th/Cermak-bound)"] = 30032
		stops["Ashland (Loop-63rd-bound)"] = 30033
		stops["Ashland/63rd (Harlem-bound)"] = 30056
		stops["Ashland/63rd (Terminal arrival)"] = 30057
		stops["Austin (Forest Pk-bound)"] = 30002
		stops["Austin (O'Hare-bound)"] = 30001
		stops["Austin (63rd-bound)"] = 30243
		stops["Austin (Harlem-bound)"] = 30244
		stops["Belmont (O'Hare Branch) (Forest Pk-bound)"] = 30013
		stops["Belmont (O'Hare Branch) (O'Hare-bound)"] = 30012
		stops["Belmont (95th-bound)"] = 30256
		stops["Belmont (Howard-bound)"] = 30255
		stops["Belmont (Kimball-Linden-bound)"] = 30257
		stops["Belmont (Loop-bound)"] = 30258
		stops["Berwyn (95th-bound)"] = 30067
		stops["Berwyn (Howard-bound)"] = 30066
		stops["Bryn Mawr (95th-bound)"] = 30268
		stops["Bryn Mawr (Howard-bound)"] = 30267
		stops["California (54th/Cermak-bound)"] = 30087
		stops["California (Loop-bound)"] = 30086
		stops["California/Milwaukee (Forest Pk-bound)"] = 30112
		stops["California (63rd-bound)"] = 30265
		stops["California (Harlem-bound)"] = 30266
		stops["California/Milwaukee (O'Hare-bound)"] = 30111
		stops["Central-Evanston (Howard-Loop-bound)"] = 30242
		stops["Central-Evanston (Linden-bound)"] = 30241
		stops["Central (63rd-bound)"] = 30054
		stops["Central (Harlem-bound)"] = 30055
		stops["Central Park (54th/Cermak-bound)"] = 30152
		stops["Central Park (Loop-bound)"] = 30151
		stops["Cermak-Chinatown (95th-bound)"] = 30194
		stops["Cermak-Chinatown (Howard-bound)"] = 30193
		stops["Chicago/Milwaukee (Forest Pk-bound)"] = 30272
		stops["Chicago/Milwaukee (O'Hare-bound)"] = 30271
		stops["Chicago/Franklin (Kimball-Linden-bound)"] = 30137
		stops["Chicago/Franklin (Loop-bound)"] = 30138
		stops["Chicago/State (95th-bound)"] = 30280
		stops["Chicago/State (Howard-bound)"] = 30279
		stops["Cicero (54th/Cermak-bound)"] = 30083
		stops["Cicero (Loop-bound)"] = 30082
		stops["Cicero (Forest Pk-bound)"] = 30188
		stops["Cicero (O'Hare-bound)"] = 30187
		stops["Cicero (63rd-bound)"] = 30094
		stops["Cicero (Harlem-bound)"] = 30009
		stops["Clark/Division (95th-bound)"] = 30122
		stops["Clark/Division (Howard-bound)"] = 30121
		stops["Clark/Lake (Inner Loop)"] = 30074
		stops["Clark/Lake (Outer Loop)"] = 30075
		stops["Clark/Lake (Forest Pk-bound)"] = 30374
		stops["Clark/Lake (O'Hare-bound)"] = 30375
		stops["Clinton (Forest Pk-bound)"] = 30085
		stops["Clinton (O'Hare-bound)"] = 30084
		stops["Clinton (Harlem-54th/Cermak-bound)"] = 30222
		stops["Clinton (Loop-63rd-bound)"] = 30221
		stops["Conservatory (63rd-bound)"] = 30291
		stops["Conservatory (Harlem-bound)"] = 30292
		stops["Cottage Grove (Terminal arrival)"] = 30139
		stops["East 63rd-Cottage Grove (Harlem-bound)"] = 30140
		stops["Cumberland (Forest Pk-bound)"] = 30045
		stops["Cumberland (O'Hare-bound)"] = 30044
		stops["Damen (54th/Cermak-bound)"] = 30041
		stops["Damen (Loop-bound)"] = 30040
		stops["Damen/Milwaukee (Forest Pk-bound)"] = 30116
		stops["Damen/Milwaukee (O'Hare-bound)"] = 30115
		stops["Damen (Kimball-bound)"] = 30018
		stops["Damen (Loop-bound)"] = 30019
		stops["Davis (Howard-Loop-bound)"] = 30011
		stops["Davis (Linden-bound)"] = 30010
		stops["Dempster (Howard-Loop-bound)"] = 30134
		stops["Dempster (Linden-bound)"] = 30133
		stops["Diversey (Kimball-Linden-bound)"] = 30103
		stops["Diversey (Loop-bound)"] = 30104
		stops["Division/Milwaukee (Forest Pk-bound)"] = 30063
		stops["Division/Milwaukee (O'Hare-bound)"] = 30062
		stops["Forest Park (O'Hare-bound)"] = 30076
		stops["Forest Park (Terminal Arrival)"] = 30077
		stops["Foster (Howard-Loop-bound)"] = 30102
		stops["Foster (Linden-bound)"] = 30101
		stops["Francisco (Kimball-bound)"] = 30167
		stops["Francisco (Loop-bound)"] = 30168
		stops["Fullerton (95th-bound)"] = 30234
		stops["Fullerton (Howard-bound)"] = 30233
		stops["Fullerton (Kimball-Linden-bound)"] = 30235
		stops["Fullerton (Loop-bound)"] = 30236
		stops["Garfield (63rd-bound)"] = 30100
		stops["Garfield (Harlem-bound)"] = 30099
		stops["Garfield-Dan Ryan (95th-bound)"] = 30224
		stops["Garfield-Dan Ryan (Howard-bound)"] = 30223
		stops["Grand/Milwaukee (Forest Pk-bound)"] = 30096
		stops["Grand/Milwaukee (O'Hare-bound)"] = 30095
		stops["Grand/State (95th-bound)"] = 30065
		stops["Grand/State (Howard-bound)"] = 30064
		stops["Granville (95th-bound)"] = 30148
		stops["Granville (Howard-bound)"] = 30147
		stops["Halsted (Loop-bound)"] = 30215
		stops["Halsted (Midway-bound)"] = 30216
		stops["Halsted/63rd (Ashland-bound)"] = 30184
		stops["Halsted/63rd (Harlem-bound)"] = 30183
		stops["Harlem (Forest Pk-bound)"] = 30190
		stops["Harlem (O'Hare-bound)"] = 30189
		stops["Harlem (O'Hare Branch) (Forest Pk-bound)"] = 30146
		stops["Harlem (O'Hare Branch) (O'Hare-bound)"] = 30145
		stops["Harlem (Terminal arrival)"] = 30004
		stops["Harlem (63rd-bound)"] = 30003
		stops["Library (Inner Loop)"] = 30166
		stops["Library (Outer Loop)"] = 30165
		stops["Harrison (95th-bound)"] = 30286
		stops["Harrison (Howard-bound)"] = 30285
		stops["Howard (NB) (Linden, Skokie-bound)"] = 30175
		stops["Howard (Terminal arrival)"] = 30176
		stops["Howard (Terminal arrival)"] = 30173
		stops["Howard (95th-Bound)"] = 30174
		stops["Illinois Medical District (Forest Pk-bound)"] = 30158
		stops["Illinois Medical District (O'Hare-bound)"] = 30157
		stops["Indiana (63rd-bound)"] = 30059
		stops["Indiana (Harlem-bound)"] = 30058
		stops["Irving Park (O'Hare Branch) (Forest Pk-bound)"] = 30108
		stops["Irving Park (O'Hare Branch) (O'Hare-bound)"] = 30107
		stops["Irving Park (Kimball-bound)"] = 30281
		stops["Irving Park (Loop-bound)"] = 30282
		stops["Jackson/Dearborn (Forest Pk-bound)"] = 30015
		stops["Jackson/Dearborn (O'Hare-bound)"] = 30014
		stops["Jackson/State (95th-bound)"] = 30110
		stops["Jackson/State (Howard-bound)"] = 30109
		stops["Jarvis (95th-bound)"] = 30228
		stops["Jarvis (Howard-bound)"] = 30227
		stops["Jefferson Park (Forest Pk-bound)"] = 30248
		stops["Jefferson Park (O'Hare-bound)"] = 30247
		stops["Kedzie (Loop-bound)"] = 30219
		stops["Kedzie (Midway-bound)"] = 30220
		stops["Kedzie (54th/Cermak-bound)"] = 30202
		stops["Kedzie (Loop-bound)"] = 30201
		stops["Kedzie (Kimball-bound)"] = 30225
		stops["Kedzie (Loop-bound)"] = 30226
		stops["Kedzie (63rd-bound)"] = 30207
		stops["Kedzie (Harlem-bound)"] = 30208
		stops["Kedzie-Homan (Forest Pk-bound)"] = 30049
		stops["Kedzie-Homan (O'Hare-bound)"] = 30048
		stops["Kimball (Loop-bound)"] = 30250
		stops["Kimball (Terminal arrival)"] = 30249
		stops["King Drive (Cottage Grove-bound)"] = 30217
		stops["King Drive (Harlem-bound)"] = 30218
		stops["Kostner (54th/Cermak-bound)"] = 30118
		stops["Kostner (Loop-bound)"] = 30117
		stops["Lake/State (95th-bound)"] = 30290
		stops["Lake/State (Howard-bound)"] = 30289
		stops["Laramie (63rd-bound)"] = 30135
		stops["Laramie (Harlem-bound)"] = 30136
		stops["LaSalle (Forest Pk-bound)"] = 30262
		stops["LaSalle (O'Hare-bound)"] = 30261
		stops["LaSalle/Van Buren (Inner Loop)"] = 30031
		stops["LaSalle/Van Buren (Outer Loop)"] = 30030
		stops["Lawrence (95th-bound)"] = 30150
		stops["Lawrence (Howard-bound)"] = 30149
		stops["Linden (Howard-Loop-bound)"] = 30204
		stops["Linden (Linden-bound)"] = 30203
		stops["Logan Square (Forest Pk-bound)"] = 30198
		stops["Logan Square (O'Hare-bound)"] = 30197
		stops["Loyola (95th-bound)"] = 30252
		stops["Loyola (Howard-bound)"] = 30251
		stops["Madison/Wabash (Inner Loop)"] = 30124
		stops["Madison/Wabash (Outer Loop)"] = 30123
		stops["Main (Howard-Loop-bound)"] = 30053
		stops["Main (Linden-bound)"] = 30052
		stops["Merchandise Mart (Kimball-Linden-bound)"] = 30090
		stops["Merchandise Mart (Loop-bound)"] = 30091
		stops["Midway (Arrival)"] = 30182
		stops["Midway (Loop-bound)"] = 30181
		stops["Monroe/Dearborn (Forest Pk-bound)"] = 30154
		stops["Monroe/Dearborn (O'Hare-bound)"] = 30153
		stops["Monroe/State (95th-bound)"] = 30212
		stops["Monroe/State (Howard-bound)"] = 30211
		stops["Montrose (Forest Pk-bound)"] = 30260
		stops["Montrose (O'Hare-bound)"] = 30259
		stops["Montrose (Kimball-bound)"] = 30287
		stops["Montrose (Loop-bound)"] = 30288
		stops["Morgan (Harlem-54th/Cermak-bound)"] = 30296
		stops["Morgan (Loop-63rd-bound)"] = 30295
		stops["Morse (95th-bound)"] = 30021
		stops["Morse (Howard-bound)"] = 30020
		stops["North/Clybourn (95th-bound)"] = 30126
		stops["North/Clybourn (Howard-bound)"] = 30125
		stops["Noyes (Howard-Loop-bound)"] = 30079
		stops["Noyes (Linden-bound)"] = 30078
		stops["Oak Park (Forest Pk-bound)"] = 30035
		stops["Oak Park (O'Hare-bound)"] = 30034
		stops["Oak Park (63rd-bound)"] = 30263
		stops["Oak Park (Harlem-bound)"] = 30264
		stops["Oakton (Dempster-Skokie-bound)"] = 30297
		stops["Oakton (Howard-bound)"] = 30298
		stops["O'Hare Airport (Forest Pk-bound)"] = 30172
		stops["O'Hare Airport (Terminal Arrival)"] = 30171
		stops["Paulina (Kimball-bound)"] = 30253
		stops["Paulina (Loop-bound)"] = 30254
		stops["Polk (54th/Cermak-bound)"] = 30200
		stops["Polk (Loop-bound)"] = 30199
		stops["Pulaski (Loop-bound)"] = 30185
		stops["Pulaski (Midway-bound)"] = 30186
		stops["Pulaski (54th/Cermak-bound)"] = 30029
		stops["Pulaski (Loop-bound)"] = 30028
		stops["Pulaski (Forest Pk-bound)"] = 30180
		stops["Pulaski (O'Hare-bound)"] = 30179
		stops["Pulaski (63rd-bound)"] = 30005
		stops["Pulaski (Harlem-bound)"] = 30006
		stops["Quincy/Wells (Inner Loop)"] = 30007
		stops["Quincy/Wells (Outer Loop)"] = 30008
		stops["Racine (Forest Pk-bound)"] = 30093
		stops["Racine (O'Hare-bound)"] = 30092
		stops["Randolph/Wabash (Inner Loop)"] = 30039
		stops["Randolph/Wabash (Outer Loop)"] = 30038
		stops["Ridgeland (63rd-bound)"] = 30119
		stops["Ridgeland (Harlem-bound)"] = 30120
		stops["Rockwell (Kimball-bound)"] = 30195
		stops["Rockwell (Loop-bound)"] = 30196
		stops["Roosevelt/Wabash (Loop-Harlem-bound)"] = 30080
		stops["Roosevelt/Wabash (Midway-63rd-bound)"] = 30081
		stops["Roosevelt/State (Howard-bound)"] = 30269
		stops["Roosevelt/State (Howard-bound)"] = 30270
		stops["Rosemont (Forest Pk-bound)"] = 30160
		stops["Rosemont (O'Hare-bound)"] = 30159
		stops["Sedgwick (Kimball-Linden-bound)"] = 30155
		stops["Sedgwick (Loop-bound)"] = 30156
		stops["Sheridan (95th-bound)"] = 30017
		stops["Sheridan (Howard-bound)"] = 30016
		stops["Sheridan (Howard-Linden-bound)"] = 30293
		stops["Sheridan (Loop-bound)"] = 30294
		stops["Skokie (Arrival)"] = 30026
		stops["Skokie (Howard-bound)"] = 30027
		stops["South Blvd (Howard-Loop-bound)"] = 30164
		stops["South Blvd (Linden-bound)"] = 30163
		stops["Southport (Kimball-bound)"] = 30070
		stops["Southport (Loop-bound)"] = 30071
		stops["Sox-35th (95th-bound)"] = 30037
		stops["Sox-35th (Howard-bound)"] = 30036
		stops["State/Lake (Inner Loop)"] = 30050
		stops["State/Lake (Outer Loop)"] = 30051
		stops["Thorndale (95th-bound)"] = 30170
		stops["Thorndale (Howard-bound)"] = 30169
		stops["UIC-Halsted (Forest Pk-bound)"] = 30069
		stops["UIC-Halsted (O'Hare-bound)"] = 30068
		stops["Washington/Dearborn (Forest Pk-bound)"] = 30073
		stops["Washington/Dearborn (O'Hare-bound)"] = 30072
		stops["Washington/Wells (Inner Loop)"] = 30141
		stops["Washington/Wells (Outer Loop)"] = 30142
		stops["Wellington (Kimball-Linden-bound)"] = 30231
		stops["Wellington (Loop-bound)"] = 30232
		stops["Western (Loop-bound)"] = 30060
		stops["Western (Midway-bound)"] = 30061
		stops["Western (54th/Cermak-bound)"] = 30144
		stops["Western (Loop-bound)"] = 30143
		stops["Western (Forest Pk-bound)"] = 30043
		stops["Western (O'Hare-bound)"] = 30042
		stops["Western/Milwaukee (Forest Pk-bound)"] = 30130
		stops["Western/Milwaukee (O'Hare-bound)"] = 30129
		stops["Western (Kimball-bound)"] = 30283
		stops["Western (Loop-bound)"] = 30284
		stops["Wilson (95th-bound)"] = 30106
		stops["Wilson (Howard-bound)"] = 30105
		return stops
	end
end
