local Sprite = require "ents.Sprite"
local Player = class("Player", Sprite)

function Player:initialize(x, y)
	Sprite.initialize(self, x, y, 40, 50)
	body = lope.newBody("dynamic", "rectangle", x, y, self.w, self.h)
end

function Player:update(dt)
end

function Player:mousepressed(x, y)
	body:applyForce(100,100,x,y)
end

function Player:draw()
	lope.draw(body)
end

return Player