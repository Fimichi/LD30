local Game = States:addState("Game")

--local bumplib = require "third.kikito.bump"
local Player = require "ents.player"
local gamera = require "lib.kikito.gamera"

function Game:enteredState()
	--bump = bumplib.newWorld(64)
	cam = gamera.new(-400,-300,1200,900)
	cam:setScale(0.5)
	self.diff = false
	love.physics.setMeter(64)
	world = love.physics.newWorld(0, 0, true)
	love.graphics.setBackgroundColor(16, 15, 21)
	player = Player:new(100,100,self.diff)
end

function Game:update(dt)
	world:update(dt)
	player:update(dt)
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
	end)
end

return Game