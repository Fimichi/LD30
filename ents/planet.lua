vegList = {
  tree
}
monsterList = {
  blob
}
do
  local _base_0 = {
    draw = function(self, x, y)
      local dt = love.timer.getDelta()
      self.rot = self.rot + dt
      love.graphics.origin()
      love.graphics.translate(x, y)
      love.graphics.rotate(self.rot)
      love.graphics.setColor(self.colour)
      love.graphics.circle("fill", 0, 0, self.size)
      for i = 1, #self.veg do
        local rem = (math.pi * 2) - self.veg[i].rad
        love.graphics.rotate(self.veg[i].rad)
        love.graphics.draw(veg[self.veg[i].pic], (size / 2) - 15, (size / 2) - 15, 0, 0.5, 0.5)
        love.graphics.rotate(rem)
      end
      for i = 1, #self.monsters do
        monsters[i]:update(dt)
        love.graphics.setColor(monsters[i].colour)
        local rem = (math.pi * 2) - self.monsters[i].rad
        love.graphics.rotate(self.monsters[i].rad)
        love.graphics.draw((function()
          local _base_1 = self.monsters[i]
          local _fn_0 = _base_1.getImage
          return function(...)
            return _fn_0(_base_1, ...)
          end
        end)(), 0, -size - blob[(math.ceil(rot * 10) % 5) + 1]:getHeight(), 0.1)
        love.graphics.rotate(rem)
      end
      love.graphics.setColor(self.colour[1], self.colour[2], 0)
      for i = 1, #self.coins do
        local rem = (math.pi * 2) - self.coins[i].rad
        love.graphics.rotate(self.coins[i].rad)
        love.graphics.circle("fill")
        love.graphics.rotate(rem)
      end
    end
  }
  _base_0.__index = _base_0
  local _class_0 = setmetatable({
    __init = function(self, choices)
      self.name = choices["name"]
      self.veg = choices["veg"]
      self.monsters = choices["monsters"]
      self.coins = choices["coins"]
      self.size = choices["size"]
      self.colour = choices["colour"]
      self.rot = 0
    end,
    __base = _base_0,
    __name = "Planet"
  }, {
    __index = _base_0,
    __call = function(cls, ...)
      local _self_0 = setmetatable({}, _base_0)
      cls.__init(_self_0, ...)
      return _self_0
    end
  })
  _base_0.__class = _class_0
  Planet = _class_0
end
do
  local _base_0 = {
    update = function(self, dt)
      self.rad = self.rad + (dt * self.speed)
      self.animPos = self.animPos + dt
      if self.animPos > self.speed then
        self.anImage = self.anImage + 1
        self.animPos = self.animPos - self.speed
        if self.anImage > #images then
          self.anImage = 1
        end
      end
    end,
    getImage = function(self)
      return monsterList[self.images][self.anImage]
    end,
    setColor = function(self, col)
      self.colour = col
      for i = 1, #(monsterList[self.images]) do
        local dat = monsterList[self.images]:getData()
        dat:mapPixel(self.sep2)
        monsterList[self.images][i]:refresh()
      end
    end,
    sep = function(self, x, y, r, g, b, a)
      if r + g + b < 500 then
        return self.colour
      else
        return 0, 0, 0, 0
      end
    end,
    sep2 = function(self, x, y, r, g, b, a)
      if r + g + b + a > 0 then
        return self.colour
      else
        return 0, 0, 0, 0
      end
    end
  }
  _base_0.__index = _base_0
  local _class_0 = setmetatable({
    __init = function(self, choices)
      self.rad = choices["rad"]
      self.images = choices["images"]
      self.animSpeed = choices["animSpeed"] or 0.5
      self.speed = choices["speed"]
      self.colour = choices["colour"]
      self.animPos = 0
      self.anImage = 1
      for i = 1, #(monsterList[self.images]) do
        local dat = monsterList[self.images]:getData()
        dat:mapPixel(self.sep)
        monsterList[self.images][i]:refresh()
      end
    end,
    __base = _base_0,
    __name = "Monster"
  }, {
    __index = _base_0,
    __call = function(cls, ...)
      local _self_0 = setmetatable({}, _base_0)
      cls.__init(_self_0, ...)
      return _self_0
    end
  })
  _base_0.__class = _class_0
  Monster = _class_0
end
