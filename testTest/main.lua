require("planet")
local tree = love.graphics.newImage("tree1.png")
local blob = { }
for i = 1, 5 do
  table.insert(blob, love.graphics.newImage("bigBlob_" .. tostring(i) .. ".png"))
end
local things = { }
table.insert(things, Entity("enemy", blob, 2, 1, 0.1))
table.insert(things, Entity("enemy", blob, 3, 2, 0.1))
table.insert(things, Entity("veg", tree, 1, 0))
love.load = function()
  plan = Planet({
    name = "Plan",
    size = 100,
    colour = {
      255,
      255,
      0
    }
  }, things)
end
love.draw = function()
  return plan:draw(400, 300)
end
