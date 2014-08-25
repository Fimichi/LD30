local Map = States:addState("Map")

local stars = {}
local rot = 0
local time = 0
local message = "Randomly choosing a connected world..."

function Map:enteredState()
	stars = {}
	for i=1,500 do
		table.insert(stars,{love.math.random(1,love.window.getWidth()-1),love.math.random(1,love.window.getHeight()-1)})
	end
	rot = 0
	time = 0
	message = "Randomly choosing a connected world..."
end

function Map:update(dt)
	rot=rot+(dt*1.5)
	time=dt+time
	if time>3 then
		if #planets>1 then message = "Selected!" else message="Couldn't find any other planets. Returning to homeworld." end
	end
	if time>4 then
		if #planets>1 then currentPlanet = love.math.random(1,#planets-1)
		else currentPlanet = 1 end
		gamestate:gotoState("Explore2")
	end
end

function Map:draw()
	love.graphics.setColor(255,255,255)
	for i=1,500 do
		love.graphics.point(stars[i][1],stars[i][2])
	end
	love.graphics.translate(500,400)
	love.graphics.rotate(rot)
	love.graphics.setColor(255,255,0)
	love.graphics.circle("fill",0,0,100)
	local dist = 180
	local rotat = 0
	local offset = 0
	for i=1,#planets do
		--go through each planet
		love.graphics.setColor(planets[i].colour)
		love.graphics.circle("fill",0,dist,planets[i].size/4)
		love.graphics.setColor(255-planets[i].colour[1],255-planets[i].colour[2],255-planets[i].colour[3])
		love.graphics.circle("line",0,dist,planets[i].size/4)
		love.graphics.setColor(0,0,0)
		love.graphics.setFont(smallFont)
		love.graphics.print(planets[i].name,-2.5*#planets[i].name,(-15/4)+dist)
		love.graphics.rotate((math.pi*2)/8)
		rotat = ((math.pi*2)/8)+rotat
		if rotat >= math.pi*2 then
			offset = offset + (math.pi*2)/32
			rotat = offset
			dist = dist + 120
		end
	end
	love.graphics.origin()
	love.graphics.setColor(255,255,255)
	love.graphics.setFont(bigFont)
	love.graphics.print(message,10,10)
end

return Map