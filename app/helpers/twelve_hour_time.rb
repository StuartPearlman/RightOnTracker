helpers do
	def twelve_hour_time(time)
		time = time.delete ':'
		am_or_pm = ''
		t = ''

		if (time.to_i <= 1200)
			t = time
			am_or_pm = " AM"
		elsif time.to_i.between?(1200,1300)
			t = time.to_i
			am_or_pm = " PM"
		else
			t = time.to_i - 1200
			am_or_pm = " PM"
		end

		return (t.to_s.size == 3)? t.to_s.insert(1,":") + am_or_pm : t.to_s.insert(2,":") + am_or_pm
	end
end
