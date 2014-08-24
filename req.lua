-- LIBRARIES

require "planet"
require "networking"

--anim8 = require "lib.kikito.anim8"
--_ = require "lib.kikito.beholder"
--bump = require "lib.kikito.bump"
--cron = require "lib.kikito.cron"
--gamera = require "lib.kikito.gamera"
class = require "lib.kikito.middleclass"
Stateful = require "lib.kikito.stateful"
--tween = require "lib.kikito.tween"
--bresenham = require "lib.kikito.bresenham"

--tiled = require "lib.tiled"

--gui = require "lib.gui"

lume = require "lib.lume"
--lurker = require "lib.lurker"

--require "lib.slam"
require "socket.http"

--navi = require "lib.navi"

-- IMAGES
blob = {} --blobs are animated, so there
for i=1,5 do
	table.insert(blob, love.graphics.newImage("assets/bigBlob_"..i..".png"))
end
blob2 = {}
for i=1,8 do
	table.insert(blob2,love.graphics.newImage("assets/blob_"..i..".png"))
end
snail = {}
for i=1,4 do
	table.insert(snail,love.graphics.newImage("assets/enemy9_"..i..".png"))
end
octopus = {}
for i=1,8 do
	table.insert(octopus,love.graphics.newImage("assets/enemy2_"..i..".png"))
end
punk = {}
for i=1,6 do
	table.insert(punk,love.graphics.newImage("assets/enemy4_"..i..".png"))
end
spider = {}
for i=1,8 do
	table.insert(spider,love.graphics.newImage("assets/enemy5_"..i..".png"))
end
doll = {}
for i=1,9 do
	table.insert(doll,love.graphics.newImage("assets/enemy10_"..i..".png"))
end

char = {}
for i=1,9 do
	table.insert(char,love.graphics.newImage("assets/walk000"..i..".png"))
end
for i=10,11 do
	table.insert(char,love.graphics.newImage("assets/walk00"..i..".png"))
end
tree = love.graphics.newImage("assets/tree1.png")
tree2 = love.graphics.newImage("assets/tree2.png")
tree3 = love.graphics.newImage("assets/tree3.png")
tree4 = love.graphics.newImage("assets/tree4.png")
tree5 = love.graphics.newImage("assets/tree5.png")
ship = love.graphics.newImage("assets/ship.png")

--now for the easy entities
--these are here purely for copying

enemies = {}
vegetation = {}
player = Player("player","char",4.8,0,0.1,{scale=0.5})
table.insert(enemies,Entity("enemy","blob",2,1,0.1,{height=-5, rotation=0.15}))
table.insert(enemies,Entity("enemy","blob2",3,2,0.1,{height=-5, rotation=0.15}))
table.insert(enemies,Entity("enemy","snail",1,0.5,0.1,{height=-5, rotation=0.15}))
table.insert(enemies,Entity("enemy","octopus",4,1.5,0.1,{height=-5, rotation=0.15}))
table.insert(enemies,Entity("enemy","punk",5,1.5,0.1,{rotation=0.15}))
table.insert(enemies,Entity("enemy","spider",4.5,2,0.1,{height=-5,rotation=0.15}))
table.insert(enemies,Entity("enemy","doll",1.5,1.5,0.1,{height=-5,rotation=0.15}))
table.insert(vegetation,Entity("veg","tree2",1,0,0.1,{height=-15}))
table.insert(vegetation,Entity("veg","tree",6,0,0.1,{height=-15}))
table.insert(vegetation,Entity("veg","tree3",3.5,0,0.1,{height=-15, rotation=0.3}))
table.insert(vegetation,Entity("veg","tree4",2,0,0.1,{height=-25}))
table.insert(vegetation,Entity("veg","tree5",4.8,0,0.1,{height=-20}))

bigFont = love.graphics.newFont(30)
smallFont = love.graphics.newFont(15)