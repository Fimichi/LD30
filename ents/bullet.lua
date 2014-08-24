local Sprite = require "ents.sprite"
local Bullet = class("Bullet", Sprite)

local mx, my
local xDir, yDir

function Bullet:initialize(x, y, passedmx, passedmy)
	Sprite.initialize(self, x, y, 2, 2)
	mx, my = passedmx, passedmy
	local ox = mx - self.cx
	local oy = my - self.cy
	local totalDist = math.sqrt(ox^2 + oy^2)
	xDir = ox/totalDist
	yDir = oy/totalDist
end

function Bullet:update(dt)
	local speed = 20 * dt
	self.x = self.x + speed * xDir
	self.y = self.y + speed * yDir
end

function Bullet:draw()
	love.graphics.setColor(255, 255, 255)
	love.graphics.circle("fill", self.x, self.y, self.w, self.h)
end

return Bullet