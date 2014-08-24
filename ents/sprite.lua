local Sprite = class("Sprite")

function Sprite:initialize(x, y, w, h)
	self.x = x
	self.y = y
	self.w = w
	self.h = h
	self.cx = x + w/2
	self.cy = y + h/2
	self.vx = 0
	self.vy = 0
	--bump:add(self, self.x, self.y, self.w, self.h)
end

function Sprite:move()
	self.x = self.x + self.vx
	self.y = self.y + self.vy
	--bump:move(self, self.x, self.y)
end

return Sprite