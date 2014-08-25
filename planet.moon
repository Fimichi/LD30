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
		@reactionFlag = true
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
	react: () =>
		if @reactionFlag
			@reactionFlag = false
			--and react!
			print @object
	finishReact: () =>
		@reactionFlag = true

export class Player
	controls: (planet) =>
		dt = love.timer.getDelta!
		l,r = love.keyboard.isDown("left") or love.keyboard.isDown("a"),love.keyboard.isDown("right") or love.keyboard.isDown("d")
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
		@smooth = 3
	draw: (x,y) =>
		@x = x
		@y = y
		if @smooth < 15
			@smooth += love.timer.getDelta!*30
		else
			@smooth = 100
		love.graphics.translate(x,y) --the planet is now the centre
		love.graphics.rotate(@rot) --if there's any rotation required
		love.graphics.setColor(@colour)
		love.graphics.circle("fill",0,0,@size,@smooth)
		love.graphics.setColor(255-@colour[1],255-@colour[2],255-@colour[3])
		love.graphics.circle("line",0,0,@size,@smooth)
		love.graphics.setColor(@colour)
		for i=1,#@entities
			@entities[i]\update(love.timer.getDelta!)
			@entities[i]\draw(@size)
		if @player
			@player\update(love.timer.getDelta!)
			@player\draw(@size)
			@player\controls(@)
			@dealWithCollisions!
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
	addEntity: (entity) =>
		table.insert(@entities,entity)
	removeEntity: (number) =>
		table.remove(@entities,number)
	addPlayer: (player) =>
		@player = player
	removePlayer: () =>
		@player = nil
	dealWithCollisions: () =>
		pos = @player.rad*10
		for i=1,#@entities
			if math.floor(@entities[i].rad * 10) == math.floor(pos)
				@entities[i]\react!
			else
				@entities[i]\finishReact!