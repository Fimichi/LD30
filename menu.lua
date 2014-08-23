local Menu = States:addState("Menu")

-- local step
local menustring = "Press enter!"
local stars = {}
local colour = {love.math.random(2,255),love.math.random(2,255),love.math.random(2,255)}
local pressed = 0
local size = love.math.random(50,150)
local rot = 0
local danger = 3
local veg = love.math.random(0,6)
local kind = 4

function Menu:enteredState()
	love.graphics.setFont(love.graphics.newFont(25))
	love.graphics.setBackgroundColor(0, 0, 0)
	-- step = 1
	for i=1,100,1 do
		table.insert(stars,{love.math.random(1,love.window.getWidth()-1),love.math.random(1,love.window.getHeight()-1)})
	end
	for i=1,#blob do
		local data = blob[i]:getData()
		data:mapPixel(function(x,y,r,g,b,a) if(r+g+b<500) then return colour[1],colour[2],colour[3],255 else return 0,0,0,0 end end)
		blob[i]:refresh()
	end
	local data = tree:getData()
	data:mapPixel(function(x,y,r,g,b,a) if(a>0) then return 0,colour[2],0 else return 0,0,0,0 end end)
	tree:refresh()
end

function Menu:update(dt)
	rot = rot + (dt/2)
	local x = love.mouse.getX()
	if(pressed == 1) then
		if x>450 and x<740 then
			size = math.floor((x-445)/3)+50
		elseif(x<=450) then
			size = math.floor(5/3)+50
		elseif(x>=740) then
			size = math.floor((740-445)/3)+50
		end
	elseif(pressed == 2) then
		--colour rX
		if x>450 and x<740 then
			colour[1] = ((x-450)/300)*255
		elseif x<=450 then
			colour[1] = 0
		elseif x>=740 then
			colour[1] = 255
		end
	elseif(pressed == 3) then
		--colour gX
		if x>450 and x<740 then
			colour[2] = ((x-450)/300)*255
		elseif x<=450 then
			colour[2] = 0
		elseif x>=740 then
			colour[2] = 255
		end
	elseif(pressed == 4) then
		--colour gX
		if x>450 and x<740 then
			colour[3] = ((x-450)/300)*255
		elseif x<=450 then
			colour[3] = 0
		elseif x>=740 then
			colour[3] = 255
		end
	elseif(pressed == 5) then
		if x>450 and x<740 then
			veg = math.ceil(((x-450)/300)*15)
		elseif x<=450 then
			veg = 0
		elseif x>=740 then
			veg = 15
		end
	elseif(pressed == 6) then
		if x>450 and x<740 then
			danger = math.ceil(((x-450)/300)*6)
		elseif x<=450 then
			danger = 1
		elseif x>=740 then
			danger = 6
		end
	elseif(pressed == 7) then
		if x>450 and x<740 then
			kind = math.ceil(((x-450)/300)*6)
		elseif x<=450 then
			kind = 1
		elseif x>=740 then
			kind = 6
		end
	end
	if(pressed == 3 or pressed == 4 or pressed == 2) then
		for i=1,#blob do
			local data = blob[i]:getData()
			data:mapPixel(function(x,y,r,g,b,a) if(r+g+b+a>0) then return colour[1],colour[2],colour[3] else return 0,0,0,0 end end)
			--basically, if there would be any colour there, it now matches the planet!
			blob[i]:refresh()
		end
		local data = tree:getData()
		data:mapPixel(function(x,y,r,g,b,a) if(a+r+g+b>0) then return 0,colour[2],0 else return 0,0,0,0 end end)
		tree:refresh()
	end
end

function Menu:keypressed(key)
	-- I didn't want to comment this out, but...
	-- if key == "return" then self:gotoState("Game")
	-- elseif step == 1 and key == "up" then step = step + 1
	-- elseif step == 2 and key == "up" then step = step + 1
	-- elseif step == 3 and key == "down" then step = step + 1
	-- elseif step == 4 and key == "down" then step = step + 1
	-- elseif step == 5 and key == "left" then step = step + 1
	-- elseif step == 6 and key == "right" then step = step + 1
	-- elseif step == 7 and key == "left" then step = step + 1
	-- elseif step == 8 and key == "right" then step = step + 1
	-- elseif step == 9 and key == "b" then step = step + 1
	-- elseif step == 10 and key == "a" then menustring = "KONAMI CODE."
	-- else step = 1 end
end

function Menu:draw()
	love.graphics.push()
	love.graphics.setColor(255,255,255)
	-- love.graphics.print(menustring, 0, 0)
	for i=1,100,1 do
		love.graphics.point(stars[i][1], stars[i][2])
	end
	--now the sliders etc
	for i=100,500,100 do
		love.graphics.line(450,i,450,i+30)
		love.graphics.line(750,i,750,i+30)
	end
	love.graphics.print("Size",450,60)
	love.graphics.print("Colour",450,160)
	love.graphics.print("Vegetation",450,260)
	love.graphics.print("Danger",450,360)
	love.graphics.print("Kindness",450,460)
	--now the actual slidey things
	love.graphics.rectangle("fill",((size-50)*3)+445,100,10,30)
	love.graphics.setColor(255,0,0)
	love.graphics.rectangle("fill",((colour[1]/255)*300)+445,196,10,10)
	love.graphics.setColor(0,255,0)
	love.graphics.rectangle("fill",((colour[2]/255)*300)+445,208,10,10)
	love.graphics.setColor(0,0,255)
	love.graphics.rectangle("fill",((colour[3]/255)*300)+445,220,10,10)
	love.graphics.setColor(255,255,255)
	love.graphics.rectangle("fill",((veg/15)*300)+445,300,10,30)
	love.graphics.rectangle("fill",((danger/6)*300)+445,400,10,30)
	love.graphics.rectangle("fill",((kind/6)*300)+445,500,10,30)
	--and finally DRAW IT!
	love.graphics.translate(220, 300)
	love.graphics.rotate(rot)
	love.graphics.setColor(colour)
	love.graphics.circle("fill", 0, 0, size)
	for i=1,veg do	
		love.graphics.draw(tree,(size/2)-15,(size/2)-15,0,0.5,0.5)
		if veg>1 then love.graphics.rotate(6.2/veg) end
	end
	love.graphics.setColor(colour[1],colour[2],0)
	love.graphics.rotate(1)
	for i=1,kind do
		love.graphics.circle("fill",size-(size/8),size-(size/8),10)
		if kind>1 then love.graphics.rotate(6.2/kind) end
	end
	love.graphics.pop()
	-- blob moves at a different speed so has its own transformation stack
	love.graphics.push()
	love.graphics.translate(220, 300)
	love.graphics.rotate(rot*1.5)
	for i=1,danger do
		love.graphics.draw(blob[(math.ceil(rot*10)%5)+1],0,-size-blob[(math.ceil(rot*10)%5)+1]:getHeight(),0.1)
		if danger>1 then love.graphics.rotate(6.2/danger) end
	end
	love.graphics.pop()
end

function Menu:mousepressed(x,y,button)
	local res = checkBounds(x,y,button)
	if (res) then
		pressed = res
	else pressed = 0 end
end

function Menu:mousereleased(x,y,button)
	pressed = 0
end

function checkBounds(x,y)
	local sizeX = ((size-50)*3)+445
	if(x>sizeX and x<sizeX+10 and y>100 and y<130) then
		-- size slider is dragged
		return 1 --slider for size == 1
	end
	local colourRX = ((colour[1]/255)*300)+445
	local colourGX = ((colour[2]/255)*300)+445
	local colourBX = ((colour[3]/255)*300)+445
	if(x>colourRX and x<colourRX+10 and y>196 and y<208) then
		return 2
	elseif(x>colourGX and x<colourGX+10 and y>208 and y<220) then
		return 3
	elseif(x>colourBX and x<colourBX+10 and y>220 and y<232) then
		return 4
	end
	local vegX = ((veg/15)*300)+445
	if(x>vegX and x<vegX+10 and y>300 and y<330) then
		return 5
	end
	local dangerX = ((danger/6)*300)+445
	if(x>dangerX and x<dangerX+10 and y>400 and y<430) then
		return 6
	end
	local kindX = ((kind/6)*300)+445
	if(x>kindX and x<kindX+10 and y>500 and y<530) then
		return 7
	end
end

return menu