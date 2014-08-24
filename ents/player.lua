local Sprite = require "ents.sprite"
local Player = class("Player", Sprite)
local Bullet = require "ents.bullet"

local maxSpeed

function Player:initialize(x, y)
	Sprite.initialize(self, x, y, 40, 40)
	self.accel = 0
	self.bclock = 0.5
	self.bullets = {}
end

function Player:update(dt)
	l.each(self.bullets, "update", dt)
	
	if love.mouse.isDown("l") then
		self.bclock = self.bclock + dt
	else
		if self.vx > 0 then
			self.vx = self.vx * -0.9 * dt
		elseif self.vx < 0 then
			self.vx = self.vx * 0.9 * dt
		end
		if self.vy > 0 then
			self.vy = self.vy * -0.9 * dt
		elseif self.vy < 0 then
			self.vy = self.vy * 0.9 * dt
		end
	end
	if self.bclock > 0.5 then
		self.bclock = self.bclock - 0.5
		self.accel = 40 * dt
		maxSpeed = 200 * dt
		self:shoot()
	end
	Sprite.move(self)
end

function Player:mousepressed()
	self.bclock = 0.5
end

function Player:shoot()
	print("SHOT")
	local mx, my = love.mouse.getPosition()
	local ox = self.cx - mx
	local oy = self.cy - my
	local totalDist = math.sqrt(ox^2 + oy^2)
	local xDir = ox/totalDist
	local yDir = oy/totalDist
	
	table.insert(self.bullets, Bullet:new(self.cx, self.cy, mx, my))
	
	self.vx = self.vx + self.accel * xDir
	self.vy = self.vy + self.accel * yDir
	--print(self.vx, self.vy)
end

function Player:draw()
	love.graphics.setColor(155, 47, 35)
	love.graphics.rectangle("fill",self.x,self.y,self.w,self.h)
	l.each(self.bullets, "draw")
end

return Player