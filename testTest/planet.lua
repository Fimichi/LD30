do
  local _base_0 = {
    update = function(self, dt)
      self.rad = self.rad + (self.speed * dt)
      while self.rad > (math.pi * 2) do
        self.rad = self.rad - (math.pi * 2)
      end
      self.currentDT = self.currentDT + dt
      if self.currentDT >= self.anim then
        self.currentFrame = self.currentFrame + 1
        if self.currentFrame > self.frames then
          self.currentFrame = 1
        end
        self.currentDT = self.currentDT - self.anim
      end
    end,
    draw = function(self, size)
      local rem = (math.pi * 2) - self.rad
      love.graphics.rotate(self.rad)
      love.graphics.draw(self.image[self.currentFrame], size + (self.image[self.currentFrame]:getHeight()), 0, math.pi / 2)
      return love.graphics.rotate(rem)
    end,
    setColour = function(self, col)
      self.colour = col
      for i = 1, self.frames do
        local dat = self.image[i]:getData()
        dat:mapPixel(function(x, y, r, g, b, a)
          if (a > 0) then
            if self.object ~= "veg" then
              return self.colour[1], self.colour[2], self.colour[3], 255
            else
              return 0, self.colour[2], 0
            end
          else
            return 0, 0, 0, 0
          end
        end)
        self.image[i]:refresh()
      end
    end
  }
  _base_0.__index = _base_0
  local _class_0 = setmetatable({
    __init = function(self, objectType, drawable, radi, speed, animationSpeed)
      if animationSpeed == nil then
        animationSpeed = 0.1
      end
      if type(drawable) == "table" then
        self.image = drawable
      else
        self.image = {
          drawable
        }
      end
      self.rad = radi
      self.speed = speed
      self.anim = animationSpeed
      self.frames = #self.image
      self.currentFrame = 1
      self.currentDT = 0
      self.colour = {
        255,
        255,
        255
      }
      self.object = objectType
      for i = 1, self.frames do
        local dat = self.image[i]:getData()
        dat:mapPixel(function(x, y, r, g, b, a)
          if (a > 0) then
            if self.object ~= "veg" then
              return self.colour[1], self.colour[2], self.colour[3], 255
            else
              return 0, self.colour[2], 0
            end
          else
            return 0, 0, 0, 0
          end
        end)
        self.image[i]:refresh()
      end
    end,
    __base = _base_0,
    __name = "Entity"
  }, {
    __index = _base_0,
    __call = function(cls, ...)
      local _self_0 = setmetatable({}, _base_0)
      cls.__init(_self_0, ...)
      return _self_0
    end
  })
  _base_0.__class = _class_0
  Entity = _class_0
end
do
  local _parent_0 = Entity
  local _base_0 = {
    controls = function(self, planet, key)
      local dt = love.timer.getDelta()
      if key == "left" then
        planet.rot = planet.rot + (dt * 10)
      elseif key == "right" then
        planet.rot = planet.rot - (dt * 10)
      end
    end
  }
  _base_0.__index = _base_0
  setmetatable(_base_0, _parent_0.__base)
  local _class_0 = setmetatable({
    __init = function(self, ...)
      return _parent_0.__init(self, ...)
    end,
    __base = _base_0,
    __name = "Player",
    __parent = _parent_0
  }, {
    __index = function(cls, name)
      local val = rawget(_base_0, name)
      if val == nil then
        return _parent_0[name]
      else
        return val
      end
    end,
    __call = function(cls, ...)
      local _self_0 = setmetatable({}, _base_0)
      cls.__init(_self_0, ...)
      return _self_0
    end
  })
  _base_0.__class = _class_0
  if _parent_0.__inherited then
    _parent_0.__inherited(_parent_0, _class_0)
  end
  Player = _class_0
end
do
  local _base_0 = {
    draw = function(self, x, y)
      love.graphics.translate(x, y)
      love.graphics.rotate(self.rot)
      love.graphics.setColor(self.colour)
      love.graphics.circle("fill", 0, 0, self.size)
      for i = 1, #self.entities do
        self.entities[i]:update(love.timer.getDelta())
        self.entities[i]:draw(self.size)
      end
      if self.player then
        self.player:update(love.timer.getDelta())
        return self.player:draw()
      end
    end,
    setColour = function(self, rgb)
      self.colour = rgb
      for i = 1, #self.entities do
        self.entities[i]:setColour(rgb)
      end
    end
  }
  _base_0.__index = _base_0
  local _class_0 = setmetatable({
    __init = function(self, options, entities, player)
      self.name = options["name"] or ""
      self.size = options["size"] or 100
      self.colour = options["colour"] or {
        255,
        255,
        255
      }
      self.entities = entities
      self.player = player
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
