require "planet"

tree = love.graphics.newImage("tree1.png")
blob = {}
for i=1,5
	table.insert(blob,love.graphics.newImage("bigBlob_#{i}.png"))

things = {}
table.insert(things,Entity("enemy",blob,2,1,0.1))
table.insert(things,Entity("enemy",blob,3,2,0.1))
table.insert(things,Entity("veg",tree,1,0))

love.load = () ->
	export plan = Planet({name: "Plan", size: 100, colour: {255,255,0}},things)

love.draw = () ->
	plan\draw(400,300)