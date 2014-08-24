local Sprite = require "Sprite"
local Player = class("Player", Sprite)

function Player:initialize(x, y)
	Sprite.initialize(self, x, y, 32, 32)
end

function Player:update(dt)
end

function Player:draw()
end

return Player