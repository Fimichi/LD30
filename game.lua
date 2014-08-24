local Game = States:addState("Game")

--local bumplib = require "third.kikito.bump"
local Player = require "ents.player"
local Elevator = require "ents.elevator"
local gamera = require "lib.kikito.gamera"

function Game:enteredState()
	--bump = bumplib.newWorld(64)
	self.diff = false
	love.physics.setMeter(64)
	world = love.physics.newWorld(0, 0, true)
	love.graphics.setBackgroundColor(16, 15, 21)
	player = Player:new(100,100,self.diff)
	elevator = Elevator:new(400,600)
	
	cam = gamera.new(-1600,-1200,4200,3600)
	cam:setScale(0.25)
	cam:setPosition(400, 300)
end

function Game:update(dt)
	world:update(dt)
	player:update(dt)
	elevator:update(dt)
end

function Game:mousepressed(x, y, b)
	if b == "l" then
		player:mousepressed(x, y)
	else
		player = Player:new(100,100,self.diff)
	end
end

function Game:draw()
	cam:draw(function(l,t,w,h)
		player:draw()
		elevator:draw()
		love.graphics.rectangle("line", 0, 0, 800, 600)
	end)
end

return Game