local Sprite = require "ents.sprite"
local Elevator = class("Elevator", Sprite)

function Elevator:initialize(x, y)
	Sprite.initialize(self, x, y, 150, 190)
	self.body = love.physics.newBody(world, self.x, self.y)
	self.shape1 = love.physics.newRectangleShape(0, 20, self.w, self.h-40)
	self.shape2 = love.physics.newRectangleShape(-65, -75, 20, 40)
	self.shape3 = love.physics.newRectangleShape(65, -75, 20, 40)
	self.fixture1 = love.physics.newFixture(self.body, self.shape1)
	self.fixture2 = love.physics.newFixture(self.body, self.shape2)
	self.fixture3 = love.physics.newFixture(self.body, self.shape3)
	self.body:setFixedRotation(true)
end

function Elevator:update(dt)
	Sprite.update(self, dt)
	self.x, self.y = self.body:getPosition()
	self.body:setY(self.y - 50 * dt)
end

function Elevator:draw()
	love.graphics.setColor(230, 225, 206)
	love.graphics.rectangle("fill", self.l, self.t, self.w, self.h)
end

return Elevator