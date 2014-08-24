-- PLANET V2
-- HOPEFULLY THIS WILL BE OKISH PERHAPS

export class Entity
	new: (objectType,drawable,radi,speed,animationSpeed=0.1,drawableOptions) =>
		@a,@image = pcall(loadstring("return #{drawable}"))
		@imageName = drawable
		if not @a
			error("BAD IMAGE")
		if type(@image) ~= "table"
			@image = {@image}
		@rad = radi
		@speed = speed
		@anim = animationSpeed
		@frames = #@image
		@currentFrame = 1
		@currentDT = 0
		@colour = {255,255,255}
		@object = objectType
		if drawableOptions
			@drawableOptions = lume.serialize(drawableOptions)
			@height = drawableOptions["height"] or 0
			@rotation = drawableOptions["rotation"] or 0
			@scaleX = drawableOptions["scale"] or drawableOptions["scaleX"] or 1
			@scaleY = drawableOptions["scale"] or drawableOptions["scaleY"] or 1
		else
			@drawableOptions = "{}"
			@height = 0
			@rotation = 0
			@scaleX = 1
			@scaleY = 1
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
		love.graphics.push!
		love.graphics.rotate(@rad)
		love.graphics.draw(@image[@currentFrame],size+(@image[@currentFrame]\getHeight!)+@height,0,(math.pi/2)+@rotation,@scaleX,@scaleY)
		love.graphics.pop!
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
	setPosition: (rad) =>
		@rad = rad
		return @

export class Player
	controls: (planet) =>
		dt = love.timer.getDelta!
		l,r = love.keyboard.isDown("left"),love.keyboard.isDown("right")
		if l
			planet\tilt(dt*2)
			@rad -= (dt*2)
			@dir = -1
		elseif r
			planet\tilt(-dt*2)
			@rad += (dt*2)
			@dir = 1
		else
			@dir = 0
	-- then the stuff below is very similar to entity WITH A CATCH (boom!)
	new: (objectType,drawable,radi,speed,animationSpeed=0.1,drawableOptions) =>
		@a,@image = pcall(loadstring("return #{drawable}"))
		@imageName = drawable
		if not @a
			error("BAD IMAGE")
		if type(@image) ~= "table"
			@image = {@image}
		@rad = radi
		@speed = speed
		@anim = animationSpeed
		@frames = #@image
		@currentFrame = 1
		@currentDT = 0
		@dir = 0
		@colour = {255,255,255}
		@object = objectType
		if drawableOptions
			@drawableOptions = lume.serialize(drawableOptions)
			@height = drawableOptions["height"] or 0
			@rotation = drawableOptions["rotation"] or 0
			@scaleX = drawableOptions["scale"] or drawableOptions["scaleX"] or 1
			@scaleY = drawableOptions["scale"] or drawableOptions["scaleY"] or 1
		else
			@drawableOptions = "{}"
			@height = 0
			@rotation = 0
			@scaleX = 1
			@scaleY = 1
	update: (dt) =>
		@rad += (@speed*dt)
		while @rad > (math.pi*2)
			@rad -= (math.pi*2)
		if @dir!=0
			@currentDT += dt
			if @currentDT >= @anim
				@currentFrame += 1
				if @currentFrame > @frames
					@currentFrame = 1
				@currentDT -= @anim
		else
			@currentFrame = 1
	draw: (size) =>
		love.graphics.push!
		if @dir == 1
			love.graphics.rotate(@rad-0.15)
		else
			love.graphics.rotate(@rad)
		if @dir == 1
			love.graphics.draw(@image[@currentFrame],size+48+@height,0,(math.pi/2)+@rotation,@scaleX,@scaleY)
		else
			love.graphics.draw(@image[@currentFrame],size+48+@height,0,(math.pi/2)+@rotation,@scaleX*-1,@scaleY)
		love.graphics.pop!

export class Planet
	new: (options,entities,player) =>
		@name = options["name"] or ""
		@size = options["size"] or 100
		@colour = options["colour"] or {255,255,255}
		@entities = entities
		@player = player --player is drawn but never recouloured
		@rot = 0
		@x = 0
		@y = 0
	draw: (x,y) =>
		@x = x
		@y = y
		love.graphics.translate(x,y) --the planet is now the centre
		love.graphics.rotate(@rot) --if there's any rotation required
		love.graphics.setColor(@colour)
		love.graphics.circle("fill",0,0,@size)
		love.graphics.setColor(255-@colour[1],255-@colour[2],255-@colour[3])
		love.graphics.circle("line",0,0,@size)
		love.graphics.setColor(@colour)
		for i=1,#@entities
			@entities[i]\update(love.timer.getDelta!)
			@entities[i]\draw(@size)
		if @player
			@player\update(love.timer.getDelta!)
			@player\draw(@size)
			@player\controls(@)
		love.graphics.setColor(0,0,0)
		love.graphics.setFont(bigFont)
		love.graphics.print(@name,-10*#@name,-15)
		love.graphics.origin!
	setColour: (rgb) =>
		@colour = rgb
		for i=1,#@entities
			@entities[i]\setColour(rgb)
	tilt: (right) =>
		@rot += right
	--calculatePosition: (mx,my) =>
		-- --first, let's work out the angle
		-- xDif = math.abs(mx-@x)
		-- yDif = math.abs(my-@y) --these are both positive
		-- ang = math.deg(math.tan(xDif/yDif)^-1) --math.deg can't be converting to negative, can it?
		-- --now let's see what we have to subtract it from to get the right final angle
		-- --WAIT!
		-- --LOVE'S COORDS HAVE Y GOING TOP TO BOTTOM, NOT VICEVERSA!
		-- print ang
		-- if mx-@x >= 0
		-- 	if my-@y <= 0
		-- 		--print "topright"
		-- 		return math.rad(ang)
		-- 	else
		-- 		--print "bottomright"
		-- 		return math.rad(180 - ang)
		-- else
		-- 	if my-@y <= 0
		-- 		--print "topleft"
		-- 		return math.rad(360 - ang)
		-- 	else
		-- 		--print "bottomleft"
		-- 		return math.rad(180 + ang)
		-- return @rot
	addEntity: (entity) =>
		table.insert(@entities,entity)
	removeEntity: (number) =>
		table.remove(@entities,number)
	addPlayer: (player) =>
		@player = player
	removePlayer: () =>
		@player = nil