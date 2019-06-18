-- loop through all objects
-- ignore if the name doesn't indicate it's a car
-- buidl up an array of the cars

-- loop through the car array
-- compute distance between all cars
-- get shortest distance

-- copy material
-- change color at the given frame


-- start of user configurable values

-- optimizations:
-- approach 1: don't  compute for every frame but every ten frames
optimize_frame_step=1

-- don't do all frames:
start_frame=1
end_frame=100

-- don't do all cars
limit_cars=4000

-- two arrays that indicate the colours to use, we have the last values in twice so we can always just interpolate between the current and the next colour
speeds=#(0,20,30,50,10000,10000000)
colours=#((color 0 0 0),(color 0 255 0),(color 255 128 0),(color 255 0 0),(color 255 0 0),(color 255 0 0))

speed_multiplier=50

beginning_of_name="Box"


-- end of user configurable values

total_time=0-timestamp()




cars=#()
for i in geometry do
(
	if (substring i.name 1 beginning_of_name.count)==beginning_of_name then
		(
			if limit_cars>0 then
			(
				append cars i
				limit_cars=limit_cars-1
			)
		)
)


-- check for missing materials
for i in cars do
(
	if i.material == undefined then
	(
		-- and fix it
		m=standardmaterial()
		i.material=m
	)
	
	-- and ensure if a material is shared we work on a separate copy
	m=copy i.material
	i.material=m
)

time_in_compare=0

animate on
(
	for l = start_frame to end_frame by optimize_frame_step do
	(
		--slidertime=l
		--format "% \n" l
		for i = 1 to cars.count do
		(
			-- compute speed
			d1=(distance (at time (l-1) cars[i].pos) (at time (l) (cars[i].pos)))
			d2=(distance (at time (l+1) cars[i].pos) (at time (l) (cars[i].pos)))
						
			v=(d1+d2)/2
			v=v*speed_multiplier
					
			-- find the coilours to interpolate between
			-- TODO interpolate, for the time being we just use the colour+1 we find
			t=-1
			for j = 1 to speeds.count do
			(
				if v>=speeds[j] then
				(
					t=j
					break
				)
			)
			-- hack to stop some weird errors
			if t>5 then
			(
				t=5
			)

			--interpolate the colours
			ds=(v-speeds[t])/(speeds[t+1]-speeds[t])
			
			r1=colours[t].r
			r2=colours[t+1].r
			g1=colours[t].g
			g2=colours[t+1].g
			b1=colours[t].b
			b2=colours[t+1].b
			
			tc=color (r1*ds+r2*(1-ds)) (g1*ds+g2*(1-ds)) (b1*ds+b2*(1-ds))
			
			format "% % % % %\n" l i v t tc
			
			at time l 
			(	
				cars[i].material.diffuse=tc
			)
		)
	)
)
total_time=total_time+timestamp()

format "total=%s comparisons=%s\n" (total_time/1000) (time_in_compare/1000)