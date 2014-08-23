-- PLANET V2
-- HOPEFULLY THIS WILL BE OKISH PERHAPS

export class Entity
	new: (objectType,drawable,radi,speed,animationSpeed=0.1) =>
		if type(drawable) == "table"
			@image = drawable
		else
			@image = {drawable}
		@rad = radi
		@speed = speed
		@anim = animationSpeed
		@frames = #@image
		@currentFrame = 1
		@currentDT = 0
		@colour = {255,255,255}
		@object = objectType
		for i=1,@frames
			dat = @image[i]\getData!
			dat\mapPixel((x,y,r,g,b,a) ->
				if(a>0)
					if @object~="veg"
						return @colour[1],@colour[2],@colour[3],255
					else
						return 0,@colour[2],0
				else
					return 0,0,0,0)
			@image[i]\refresh!
	update: (dt) =>
		@rad += (@speed*dt)
		while @rad > (math.pi*2)
			@rad -= (math.pi*2)
		@currentDT += dt
		if @currentDT >= @anim
			@currentFrame += 1
			if @currentFrame > @frames
				@currentFrame = 1
			@currentDT -= @anim
	draw: (size) =>
		rem = (math.pi*2)-@rad
		love.graphics.rotate(@rad)
		love.graphics.draw(@image[@currentFrame],size+(@image[@currentFrame]\getHeight!),0,math.pi/2)
		love.graphics.rotate(rem)
	setColour: (col) =>
		@colour = col
		for i=1,@frames
			dat = @image[i]\getData!
			dat\mapPixel((x,y,r,g,b,a) ->
				if(a>0)
					if @object~="veg"
						return @colour[1],@colour[2],@colour[3],255
					else
						return 0,@colour[2],0
				else
					return 0,0,0,0)
			@image[i]\refresh!

export class Player extends Entity
	controls: (planet,key) =>
		dt = love.timer.getDelta!
		if key=="left"
			planet.rot += (dt*10)
		elseif key=="right"
			planet.rot -= (dt*10)

export class Planet
	new: (options,entities,player) =>
		@name = options["name"] or ""
		@size = options["size"] or 100
		@colour = options["colour"] or {255,255,255}
		@entities = entities
		@player = player --player is drawn but never recouloured
		@rot = 0
	draw: (x,y) =>
		love.graphics.translate(x,y) --the planet is now the centre
		love.graphics.rotate(@rot) --if there's any rotation required
		love.graphics.setColor(@colour)
		love.graphics.circle("fill",0,0,@size)
		for i=1,#@entities
			@entities[i]\update(love.timer.getDelta!)
			@entities[i]\draw(@size)
		if @player
			@player\update(love.timer.getDelta!)
			@player\draw!
	setColour: (rgb) =>
		@colour = rgb
		for i=1,#@entities
			@entities[i]\setColour(rgb)