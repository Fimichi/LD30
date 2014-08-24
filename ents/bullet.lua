local Sprite = require "ents.sprite"
local Bullet = class("Bullet", Sprite)

function Bullet:initialize(x, y, mx, my)
	Sprite.initialize(self, x, y, 2, 2)
	local ox = mx - self.cx
	local oy = my - self.cy
	local totalDist = math.sqrt(ox^2 + oy^2)
	self.xDir = ox/totalDist
	self.yDir = oy/totalDist
	self.alive = 0
end

function Bullet:update(dt)
	self.alive = 1 * dt
	local speed = 800 * dt
	self.x = self.x + speed * self.xDir
	self.y = self.y + speed * self.yDir
	if self.alive > 3 then
		self = nil
	end
end

function Bullet:draw()
	love.graphics.setColor(255, 255, 255)
	love.graphics.circle("fill", self.x, self.y, 4)
end

return Bullet