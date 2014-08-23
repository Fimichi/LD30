-- LIBRARIES

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

--l = require "lib.lume"
--lurker = require "lib.lurker"

--require "lib.slam"

--navi = require "lib.navi"

-- IMAGES
blob = {} --blobs are animated, so there
for i=1,5 do
	table.insert(blob, love.graphics.newImage("assets/jimpBlob/bigBlob_"..i..".png"))
	blob[i]:setFilter("nearest","nearest")
	blob[i]:refresh()
end
tree = love.graphics.newImage("assets/tree.png")