-- A NOTE:
-- THESE CLASSES ARE DESIGNED TO RECONSTRUCT THE TABLES PROVIDED BY THE SERVER, NOT TO JUST BE THE BE ALL AND END ALL 

export class Planet
	new: (choices) =>
		@name = choices["name"] --who's planet is this? what are they doing?
		@veg = choices["veg"] --what trees are there? type and location on the planet in radians
		@monsters = choices["monsters"] --all the monsters, which are of class Monster
		@coins = choices["coins"] --all the coins, a list of position in radians on the planet and height
		@size = choices["size"] --size in pixels (radius, to be precise)
		@colour = choices["colour"] --if you can't guess what this is then I'm very surprised
		@rot = 0 --current rotation
	draw: (x,y) =>
		dt = love.timer.getDelta!
		@rot += dt
		love.graphics.origin!
		love.graphics.translate(x,y)
		love.graphics.rotate(@rot)
		--now we're in position! let's draw the planet!
		love.graphics.setColor(@colour)
		love.graphics.circle("fill",0,0,@size)
		--now the vegetation!
		for i=1,#@veg
			rem = (math.pi*2)-@veg[i].rad --get the remaining rotation left
			love.graphics.rotate(@veg[i].rad)
			love.graphics.draw(veg[@veg[i].pic],(size/2)-15,(size/2)-15,0,0.5,0.5)
			love.graphics.rotate(rem) --and rotate back to the main point
		--monsters! rar!
		for i=1,#@monsters
			monsters[i]\update(dt)
			love.graphics.setColor(monsters[i].colour)
			rem = (math.pi*2)-@monsters[i].rad
			love.graphics.rotate(@monsters[i].rad)
			love.graphics.draw(@monsters[i]\getImage,0,-size-blob[(math.ceil(rot*10)%5)+1]\getHeight(),0.1)
			love.graphics.rotate(rem)
		love.graphics.setColor(@colour[1],@colour[2],0)
		for i=1,#@coins
			rem = (math.pi*2)-@coins[i].rad
			love.graphics.rotate(@coins[i].rad)
			love.graphics.circle("fill")
			love.graphics.rotate(rem)


export class Monster --todo
	new: (choices) =>
		@rad = choices["rad"]
		@images = choices["images"]
		@animSpeed = choices["animSpeed"] or 0.5
		@speed = choices["speed"] --as a dt multiplier
		@colour = choices["colour"]
		@animPos = 0
		@anImage = 1
		for i=1,#(monsterList[@images])
			dat = monsterList[@images]\getData!
			dat\mapPixel(@sep)
			monsterList[@images][i]\refresh!
	update: (dt) =>
		@rad += (dt*@speed)
		@animPos += dt
		if @animPos > @speed
			@anImage+=1
			@animPos -= @speed
			if @anImage>#images
				@anImage=1
	getImage: () =>
		return monsterList[@images][@anImage]
	setColor: (col) =>
		@colour = col
		for i=1,#(monsterList[@images])
			dat = monsterList[@images]\getData!
			dat\mapPixel(@sep2)
			monsterList[@images][i]\refresh!
	sep: (x,y,r,g,b,a) =>
		if r+g+b<500
			return @colour
		else
			return 0,0,0,0
	sep2: (x,y,r,g,b,a) =>
		if r+g+b+a>0
			return @colour
		else
			return 0,0,0,0