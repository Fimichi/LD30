local Sprite = require "ents.sprite"
local Elevator = class("Elevator", Sprite)

function Elevator:initialize(x, y)
	Sprite.initialize(self, x, y, 150, 190)
	self.body = love.physics.newBody(world, self.x, self.y)
	self.shape = love.physics.newRectangleShape(self.w, self.h)
	self.fixture = love.physics.newFixture(self.body, self.shape)
	self.body:setFixedRotation(true)
end

function Elevator:update(dt)
	self.x, self.y = self.body:getPosition()
	self.body:setY(self.y - 50 * dt)
end

function Elevator:draw()
	love.graphics.setColor(230, 225, 206)
	love.graphics.polygon("fill", self.body:getWorldPoints(self.shape:getPoints()))
end

return Elevator