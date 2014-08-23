require "planet"

export blob = {love.graphics.newImage("bigBlob_1.png"),love.graphics.newImage("bigBlob_2.png"),love.graphics.newImage("bigBlob_3.png"),love.graphics.newImage("bigBlob_4.png"),love.graphics.newImage("bigBlob_5.png")}
export tree = love.graphics.newImage("tree.png")

export vegList = {tree}
export monsterList = {blob}
export plan

love.load = () ->
	plan = Planet({name: "BOB", veg: {{rad: 1, pic: 1},{rad: 2, pic: 1}}, monsters: {Monster({rad: 1,images: 1,animSpeed:0.1,speed: 2,colour: {255,255,255}})},coins: {{rad: 1.4, height: 10}}, colour: {255,255,255}, size: 100})

love.draw = () ->
	plan\draw(250,250,false)