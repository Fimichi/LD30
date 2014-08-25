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
      love.graphics.push()
      love.graphics.rotate(self.rad)
      love.graphics.draw(self.image[self.currentFrame], size + (self.image[self.currentFrame]:getHeight()) + self.height, 0, (math.pi / 2) + self.rotation, self.scaleX, self.scaleY)
      return love.graphics.pop()
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
      return self
    end,
    setPosition = function(self, rad)
      self.rad = rad
      return self
    end,
    react = function(self)
      if self.reactionFlag then
        print(self.sound)
        if self.sound then
          return love.audio.play(self.sound)
        end
      end
    end,
    finishReact = function(self) end
  }
  _base_0.__index = _base_0
  local _class_0 = setmetatable({
    __init = function(self, objectType, drawable, radi, speed, animationSpeed, sound, drawableOptions)
      if animationSpeed == nil then
        animationSpeed = 0.1
      end
      self.a, self.image = pcall(loadstring("return " .. tostring(drawable)))
      self.imageName = drawable
      if not self.a then
        error("BAD IMAGE")
      end
      if type(self.image) ~= "table" then
        self.image = {
          self.image
        }
      end
      self.soundName = sound
      self.b, self.sound = pcall(loadstring("return " .. tostring(sound)))
      if not self.b then
        self.sound = ""
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
      self.reactionFlag = true
      if drawableOptions then
        self.drawableOptions = lume.serialize(drawableOptions)
        self.height = drawableOptions["height"] or 0
        self.rotation = drawableOptions["rotation"] or 0
        self.scaleX = drawableOptions["scale"] or drawableOptions["scaleX"] or 1
        self.scaleY = drawableOptions["scale"] or drawableOptions["scaleY"] or 1
      else
        self.drawableOptions = "{}"
        self.height = 0
        self.rotation = 0
        self.scaleX = 1
        self.scaleY = 1
      end
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
  local _base_0 = {
    controls = function(self, planet)
      local dt = love.timer.getDelta()
      local l, r = love.keyboard.isDown("left") or love.keyboard.isDown("a"), love.keyboard.isDown("right") or love.keyboard.isDown("d")
      if l then
        planet:tilt(dt * 2)
        self.rad = self.rad - (dt * 2)
        self.dir = -1
      elseif r then
        planet:tilt(-dt * 2)
        self.rad = self.rad + (dt * 2)
        self.dir = 1
      else
        self.dir = 0
      end
    end,
    update = function(self, dt)
      self.rad = self.rad + (self.speed * dt)
      while self.rad > (math.pi * 2) do
        self.rad = self.rad - (math.pi * 2)
      end
      if self.dir ~= 0 then
        self.currentDT = self.currentDT + dt
        if self.currentDT >= self.anim then
          self.currentFrame = self.currentFrame + 1
          if self.currentFrame > self.frames then
            self.currentFrame = 1
          end
          self.currentDT = self.currentDT - self.anim
        end
      else
        self.currentFrame = 1
      end
    end,
    draw = function(self, size)
      love.graphics.push()
      if self.dir == 1 then
        love.graphics.rotate(self.rad - 0.15)
      else
        love.graphics.rotate(self.rad)
      end
      if self.dir == 1 then
        love.graphics.draw(self.image[self.currentFrame], size + 48 + self.height, 0, (math.pi / 2) + self.rotation, self.scaleX, self.scaleY)
      else
        love.graphics.draw(self.image[self.currentFrame], size + 48 + self.height, 0, (math.pi / 2) + self.rotation, self.scaleX * -1, self.scaleY)
      end
      return love.graphics.pop()
    end
  }
  _base_0.__index = _base_0
  local _class_0 = setmetatable({
    __init = function(self, objectType, drawable, radi, speed, animationSpeed, drawableOptions)
      if animationSpeed == nil then
        animationSpeed = 0.1
      end
      self.a, self.image = pcall(loadstring("return " .. tostring(drawable)))
      self.imageName = drawable
      if not self.a then
        error("BAD IMAGE")
      end
      if type(self.image) ~= "table" then
        self.image = {
          self.image
        }
      end
      self.rad = radi
      self.speed = speed
      self.anim = animationSpeed
      self.frames = #self.image
      self.currentFrame = 1
      self.currentDT = 0
      self.dir = 0
      self.colour = {
        255,
        255,
        255
      }
      self.object = objectType
      if drawableOptions then
        self.drawableOptions = lume.serialize(drawableOptions)
        self.height = drawableOptions["height"] or 0
        self.rotation = drawableOptions["rotation"] or 0
        self.scaleX = drawableOptions["scale"] or drawableOptions["scaleX"] or 1
        self.scaleY = drawableOptions["scale"] or drawableOptions["scaleY"] or 1
      else
        self.drawableOptions = "{}"
        self.height = 0
        self.rotation = 0
        self.scaleX = 1
        self.scaleY = 1
      end
    end,
    __base = _base_0,
    __name = "Player"
  }, {
    __index = _base_0,
    __call = function(cls, ...)
      local _self_0 = setmetatable({}, _base_0)
      cls.__init(_self_0, ...)
      return _self_0
    end
  })
  _base_0.__class = _class_0
  Player = _class_0
end
do
  local _base_0 = {
    draw = function(self, x, y)
      self.x = x
      self.y = y
      if self.smooth < 15 then
        self.smooth = self.smooth + (love.timer.getDelta() * 30)
      else
        self.smooth = 100
      end
      love.graphics.translate(x, y)
      love.graphics.rotate(self.rot)
      love.graphics.setColor(self.colour)
      love.graphics.circle("fill", 0, 0, self.size, self.smooth)
      love.graphics.setColor(255 - self.colour[1], 255 - self.colour[2], 255 - self.colour[3])
      love.graphics.circle("line", 0, 0, self.size, self.smooth)
      love.graphics.setColor(self.colour)
      for i = 1, #self.entities do
        self.entities[i]:update(love.timer.getDelta())
        self.entities[i]:draw(self.size)
      end
      if self.player then
        self.player:update(love.timer.getDelta())
        self.player:draw(self.size)
        self.player:controls(self)
        self:dealWithCollisions()
      end
      love.graphics.setColor(0, 0, 0)
      love.graphics.setFont(bigFont)
      love.graphics.print(self.name, -10 * #self.name, -15)
      return love.graphics.origin()
    end,
    setColour = function(self, rgb)
      self.colour = rgb
      for i = 1, #self.entities do
        self.entities[i]:setColour(rgb)
      end
    end,
    tilt = function(self, right)
      self.rot = self.rot + right
    end,
    addEntity = function(self, entity)
      return table.insert(self.entities, entity)
    end,
    removeEntity = function(self, number)
      return table.remove(self.entities, number)
    end,
    addPlayer = function(self, player)
      self.player = player
    end,
    removePlayer = function(self)
      self.player = nil
    end,
    dealWithCollisions = function(self)
      local pos = self.player.rad
      for i = 1, #self.entities do
        if math.floor(self.entities[i].rad) == math.floor(pos) then
          self.entities[i]:react()
        else
          self.entities[i]:finishReact()
        end
      end
    end,
    scaleDown = function(self, div)
      self.size = self.size / div
      for i = 1, #self.entities do
        self.entities[i].scaleX = self.entities[i].scaleX / div
        self.entities[i].scaleY = self.entities[i].scaleY / div
        self.entities[i].height = self.entities[i].height / div
      end
    end,
    scaleUp = function(self, multi)
      self.size = self.size * multi
      for i = 1, #self.entities do
        self.entities[i].scaleX = self.entities[i].scaleX * multi
        self.entities[i].scaleY = self.entities[i].scaleY * multi
        self.entities[i].height = self.entities[i].height * div
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
      self.x = 0
      self.y = 0
      self.smooth = 3
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
