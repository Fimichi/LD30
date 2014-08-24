local Sprite = require "ents.sprite"
local Player = class("Player", Sprite)
local Bullet = require "ents.bullet"

local clockmax = 0.2

function Player:initialize(x, y, difficult)
	Sprite.initialize(self, x, y, 40, 40)
	self.bclock = clockmax
	self.bullets = {}
	
	self.body = love.physics.newBody(world, self.cx, self.cy, "dynamic")
	self.shape = love.physics.newRectangleShape(self.w, self.h)
	self.fixture = love.physics.newFixture(self.body, self.shape)
	self.body:setFixedRotation(true)
	if not difficult then
		self.body:setLinearDamping(0.1)
	end
end

function Player:mousepressed()
	self.bclock = clockmax
end

function Player:update(dt)
	l.each(self.bullets, "update", dt)
	
	self.cx, self.cy = self.body:getPosition()
	
	if love.mouse.isDown("l") then
		self.bclock = self.bclock + dt
	end
	if self.bclock > clockmax then
		self.bclock = self.bclock - clockmax
		self:shoot()
	end
	--Sprite.move(self)
end

function Player:shoot()
	print("SHOT")
	local speed = 400
	local mx, my = love.mouse.getPosition()
	mx, my = cam:toWorld(mx, my)
	local ox = self.cx - mx
	local oy = self.cy - my
	local totalDist = math.sqrt(ox^2 + oy^2)
	local xDir = ox/totalDist
	local yDir = oy/totalDist
	
	self.body:applyForce(speed*xDir, speed*yDir)
	
	table.insert(self.bullets, Bullet:new(self.cx, self.cy, mx, my))
end

function Player:draw()
	love.graphics.setColor(155, 47, 35)
	love.graphics.polygon("fill", self.body:getWorldPoints(self.shape:getPoints()))
	l.each(self.bullets, "draw")
end

return Player