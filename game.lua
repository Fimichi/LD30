local Game = States:addState("Game")

--local bumplib = require "third.kikito.bump"
local Player = require "ents.player"

function Game:enteredState()
	--WORLD:setGravity(0,0)
	--bump = bumplib.newWorld(64)
	love.graphics.setBackgroundColor(16, 15, 21)
	player = Player:new(100,100)
end

function Game:update(dt)
	player:update(dt)
	lope.update(dt)
end

function Game:draw()
	player:draw()
end

function Game:mousepressed(x, y, button)
	if button == "l" then
		player:mousepressed(x, y)
	end
end

return Game