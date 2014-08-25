local Game = States:addState("Game")

local bumplib = require "lib.kikito.bump"
local Player = require "ents.player"
local Elevator = require "ents.elevator"
local gamera = require "lib.kikito.gamera"

local imgStars = love.graphics.newImage("assets/stars.png")

function Game:enteredState()
	bump = bumplib.newWorld(64)
	self.diff = false
	love.physics.setMeter(64)
	world = love.physics.newWorld(0, 0, true)
	love.graphics.setBackgroundColor(16, 15, 21)
	player = Player:new(100,100,self.diff)
	elev = Elevator:new(400,600)
	
	cam = gamera.new(-1600,-math.huge,4200,math.huge)
	cam:setScale(0.75) --max zoom-out
	cam:setPosition(400, 300)
end

function Game:update(dt)
	world:update(dt)
	player:update(dt)
	elev:update(dt)
	cam:setPosition(player.x, player.y)
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
		love.graphics.draw(imgStars, 0, 0)
		player:draw()
		elev:draw()
	end)
end

return Game