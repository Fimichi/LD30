local Menu = States:addState("Menu")

local stars = {}
local prompt = ""
local cursor = "|"
local clock = 0

function Menu:enteredState()
	love.graphics.setBackgroundColor(0, 0, 0)
	-- step = 1
	for i=1,100,1 do
		table.insert(stars,{love.math.random(1,love.window.getWidth()-1),love.math.random(1,love.window.getHeight()-1)})
	end
end

function Menu:update(dt)
	if not prompt then
		myPlanet:tilt(dt)
	else
		clock = clock + dt
		if clock > 1 then
			cursor = ""
		end
		if clock > 1.5 then
			cursor = "|"
			clock = clock - 1.5
		end
	end
end

function Menu:textinput(text)
	if prompt then prompt = prompt .. text end
end

function Menu:keypressed(key)
	if key=="backspace" then
		prompt = prompt:sub(0,-2)
	elseif key=="return" then
		myPlanet = Planet({name=prompt,size=love.math.random(80,200),colour={love.math.random(0,255),love.math.random(0,255),love.math.random(0,255)}},{})
		prompt = false
	end
end

function Menu:draw()
	love.graphics.setFont(bigFont)
	love.graphics.setColor(255,255,255)
	love.graphics.origin()
	for i=1,100,1 do
		love.graphics.point(stars[i][1], stars[i][2])
	end
	if not prompt then
		--draw the world!
		myPlanet:draw(400,300)
	else
		--ask for its name!
		love.graphics.print("What would you like your planet to be called?",50,200)
		love.graphics.print("(type and then press enter)",180,240)
		love.graphics.printf(prompt..cursor,100,290,600,"center")
	end
	love.graphics.origin() --for the pause screen
end

-- function Menu:mousepressed(x,y,button)
-- 	local v = vegetation[1]:setPosition(0)
-- 	if not prompt then myPlanet:addEntity(v) end
-- end

function Menu:mousereleased(x,y,button)

end

return Menu