local Explore = States:addState("Explore")

local stars = {}
local cursor = "|"
local clock = 0
local inventory = {}
local possibleItems = {{'Entity("enemy","blob",3,2,0.1,{height=-5, rotation=0.15})',"blob"},{'Entity("enemy","blob2",3,2,0.1,{height=-5, rotation=0.15})',"blob2"},{'Entity("enemy","snail",1,0.5,0.1,{height=-5, rotation=0.15})',"snail"},{'Entity("enemy","octopus",4,1.5,0.1,{height=-5, rotation=0.15})',"octopus"},{'Entity("enemy","punk",5,1.5,0.1,{rotation=0.15})',"punk"},{'Entity("enemy","spider",4.5,2,0.1,{height=-5,rotation=0.15})',"spider"},{'Entity("enemy","doll",1.5,1.5,0.1,{height=-5,rotation=0.15})',"doll"},{'Entity("veg","tree2",1,0,0.1,{height=-15})',"tree2"},{'Entity("veg","tree",6,0,0.1,{height=-15})',"tree"},{'Entity("veg","tree3",3.5,0,0.1,{height=-15, rotation=0.3})',"tree3"},{'Entity("veg","tree4",2,0,0.1,{height=-25})',"tree4"},{'Entity("veg","tree5",4.8,0,0.1,{height=-20})',"tree5"}} -- a fluffing weird way of doing this
local leaving = false

function Explore:enteredState()
	love.graphics.setBackgroundColor(0, 0, 0)
	-- step = 1
	for i=1,100,1 do
		table.insert(stars,{love.math.random(1,love.window.getWidth()-1),love.math.random(1,love.window.getHeight()-1)})
	end
	if firstPlanet then
		--you get stuff!
		for i=1,6 do
			table.insert(inventory,love.math.random(1,#possibleItems))
		end
	end
	leaving = false
end

function Explore:update(dt)
	if not prompt then
		--myPlanet:tilt(dt)
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

function Explore:textinput(text)
	if prompt then prompt = prompt .. text end
end

function Explore:keypressed(key)
	if prompt then
		if key=="backspace" then
			prompt = prompt:sub(0,-2)
		elseif key=="return" then
			myPlanet = Planet({name=prompt,size=love.math.random(80,200),colour={love.math.random(0,255),love.math.random(0,255),love.math.random(0,255)}},{Entity("spaceship","ship",0,0,0.1,{height=-15, rotation=0.25})},player)
			prompt = false
		end
	end
	--print (inventory[1],inventory[2],inventory[3],inventory[4],inventory[5],inventory[6])
	if not prompt and not leaving then
		if key=="1" then
			if inventory[1]>0 then
				local ent = loadstring("return "..possibleItems[inventory[1]][1])()
				myPlanet:addEntity(ent:setPosition(player.rad))
				inventory[1] = 0
			end
		elseif key=="2" then
			if inventory[2]>0 then
				local ent = loadstring("return "..possibleItems[inventory[2]][1])()
				myPlanet:addEntity(ent:setPosition(player.rad))
				inventory[2] = 0
			end
		elseif key=="3" then
			if inventory[3]>0 then
				local ent = loadstring("return "..possibleItems[inventory[3]][1])()
				myPlanet:addEntity(ent:setPosition(player.rad))
				inventory[3] = 0
			end
		elseif key=="4" then
			if inventory[4]>0 then
				local ent = loadstring("return "..possibleItems[inventory[4]][1])()
				myPlanet:addEntity(ent:setPosition(player.rad))
				inventory[4] = 0
			end
		elseif key=="5" then
			if inventory[5]>0 then
				local ent = loadstring("return "..possibleItems[inventory[5]][1])()
				myPlanet:addEntity(ent:setPosition(player.rad))
				inventory[5] = 0
			end
		elseif key=="6" then
			if inventory[6]>0 then
				local ent = loadstring("return "..possibleItems[inventory[6]][1])()
				myPlanet:addEntity(ent:setPosition(player.rad))
				inventory[6] = 0
			end
		end
		if key=="up" then
			if(player.rad>0 and player.rad<1) then
				leaving = true
				myPlanet:removePlayer()
			end
		end
	end
end

function Explore:draw()
	love.graphics.setFont(bigFont)
	love.graphics.setColor(255,255,255)
	love.graphics.origin()
	for i=1,100,1 do
		love.graphics.point(stars[i][1], stars[i][2])
	end
	if not prompt then
		--draw the world!
		myPlanet:draw(400,300)
		love.graphics.origin()
		love.graphics.setColor(255,255,255)
		--love.graphics.print(player.rad,0,0)
		if not leaving then
			for i=1,6 do
				if inventory[i]>0 then
					local img = loadstring("return "..possibleItems[inventory[i]][2])()
					if type(img)=="table" then img=img[1] end
					love.graphics.draw(img,(i)*100,500)
					love.graphics.print(i,i*100,530)
				end
			end
			if firstPlanet then
				love.graphics.setFont(smallFont)
				love.graphics.print("Welcome to your planet! Press left and right to move.",350,10)
				love.graphics.print("Press 1-6 to place the corresponding item on your planet.",350,25)
				love.graphics.print("Once you're done with placing stuff, press up in front of your",350,40)
				love.graphics.print("ship to leave for another person's planet. Enjoy!",350,55)
			end
		else
			myPlanet.entities[1].height = myPlanet.entities[1].height + 200*love.timer.getDelta()
			if firstPlanet then 
				love.graphics.setFont(bigFont)
				love.graphics.print("Connecting to Internet to retrieve other",50,100)
				love.graphics.print("CONNECTED worlds... (max points for theme please)",5,130)
			end
			if myPlanet.entities[1].height > 200 then
				if firstPlanet then
					planets = convertToSendable(myPlanet)
				end
				gamestate:gotoState("Game")
			end
		end
	else
		--ask for its name!
		love.graphics.print("What would you like your planet to be called?",50,200)
		love.graphics.print("(type and then press enter)",180,240)
		love.graphics.printf(prompt..cursor,100,290,600,"center")
	end
	love.graphics.origin() --for the pause screen
end

function Explore:mousereleased(x,y,button)

end

return Explore