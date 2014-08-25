local Sprite = require "ents.sprite"
local Player = class("Player", Sprite)
local Bullet = require "ents.bullet"

local clockmax = 0.2
local damp = 0.6

function Player:initialize(x, y, difficult)
	Sprite.initialize(self, x, y, 40, 40)
	self.name = "player"
	self.bclock = clockmax
	self.bullets = {}
	self.diff = difficult
	
	self.hands = {}
	self.hands["x"] = 0
	self.hands["y"] = 0
	
	self.body = love.physics.newBody(world, self.x, self.y, "dynamic")
	self.shape = love.physics.newRectangleShape(self.w, self.h)
	self.fixture = love.physics.newFixture(self.body, self.shape)
	self.body:setFixedRotation(true)
end

function Player:mousepressed()
	self.bclock = clockmax
end

function Player:update(dt)
	Sprite.update(self, dt)
	
	for i, bullet in pairs(self.bullets) do
		bullet:update(dt)
		if bullet.alive >= 3 then
			table.remove(self.bullets, i)
			bullet = nil
		end
	end
	
	self.x, self.y = self.body:getPosition()
	
	if love.mouse.isDown("l") then
		self.bclock = self.bclock + dt
		self.body:setLinearDamping(0)
	elseif not self.diff then
		self.body:setLinearDamping(damp)
	end
	if self.bclock > clockmax then
		self.bclock = self.bclock - clockmax
		self:shoot()
	end
end

function Player:shoot()
	local speed = 1200
	local mx, my = love.mouse.getPosition()
	mx, my = cam:toWorld(mx, my)
	local ox = self.x - mx
	local oy = self.y - my
	local totalDist = math.sqrt(ox^2 + oy^2)
	local xDir = ox/totalDist
	local yDir = oy/totalDist
	
	self.body:applyForce(speed*xDir, speed*yDir)
	
	table.insert(self.bullets, Bullet:new(self.x, self.y, mx, my))
end

function Player:draw()
	love.graphics.setColor(155, 47, 35)
	love.graphics.polygon("fill", self.body:getWorldPoints(self.shape:getPoints()))
	l.each(self.bullets, "draw")
end

return Player