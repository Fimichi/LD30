local Explore2 = States:addState("Explore2")

local stars = {}
local cursor = "|"
local leaving = false

function Explore2:enteredState()
	myPlanet = planets[currentPlanet]
	myPlanet:addPlayer(player)
	myPlanet.player.rad = 4.8
	love.graphics.setBackgroundColor(0, 0, 0)
	-- step = 1
	for i=1,100,1 do
		table.insert(stars,{love.math.random(1,love.window.getWidth()-1),love.math.random(1,love.window.getHeight()-1)})
	end
	leaving = false
	love.audio.play(bg[love.math.random(1,2)])
end

function Explore2:update(dt)
	if love.math.random(0,500) > 499 then --not very often
		if((not bg[1]:isPlaying()) and (not bg[2]:isPlaying())) then
			love.audio.play(bg[love.math.random(1,2)])
		end
	end
end

function Explore2:keypressed(key)
	--print (inventory[1],inventory[2],inventory[3],inventory[4],inventory[5],inventory[6])
	if not prompt and not leaving then
		if key=="up" or key=="w" then
			if(player.rad>0 and player.rad<1) then
				leaving = true
				myPlanet:removePlayer()
			end
		end
	end
end

function Explore2:draw()
	love.graphics.setFont(bigFont)
	love.graphics.setColor(255,255,255)
	love.graphics.origin()
	for i=1,100,1 do
		love.graphics.point(stars[i][1], stars[i][2])
	end
	--draw the world!
	myPlanet:draw(400,300)
	love.graphics.origin()
	love.graphics.setColor(255,255,255)
	--love.graphics.print(player.rad,0,0)
	if leaving then
		myPlanet.entities[1].height = myPlanet.entities[1].height + 200*love.timer.getDelta()
		if myPlanet.entities[1].height > 200 then
			myPlanet.entities[1].height = -15
			gamestate:gotoState("Map")
		end
	end
	love.graphics.origin() --for the pause screen
end

function Explore2:mousereleased(x,y,button)

end

return Explore2