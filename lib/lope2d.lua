--[[
	Lope2D (Love2D Physics Engine)
	Made by Erli Moen, 2013
]]

WORLD_METER = 32

--World gravity
WORLD_GRAVITY = {}
WORLD_GRAVITY.x = 0
WORLD_GRAVITY.y = 9.81

--Initialisation
WORLD = love.physics.newWorld(WORLD_GRAVITY.x*WORLD_METER,
							  WORLD_GRAVITY.y*WORLD_METER, true)
love.physics.setMeter(WORLD_METER)

lope = {
	objectsGroup = {}
}
lope.objectsGroup["Default"] = {}

-- newBody( bodyType, shapeType, [ x, y, width / radius, height / angle, angle / nil ] )
function lope.newBody(bodyType, shapeType, ...)
	local arg = {...}
	if(bodyType ~= "static" and bodyType ~= "dynamic" and bodyType ~= "kinematic" ) then
		return nil
	end

	local Body = {
	BODY_MARKER = 1, --Is table a 'Body'
	group = "Default",
	image = nil,
	shape = nil,
	vertices = {},
	shapeType = shapeType,
	body = love.physics.newBody(WORLD, arg[1] or 0, arg[2] or 0, bodyType),
	fixture = nil}

	function Body:updateVertices()
		local a = self.width/2
		local b = self.height/2
		local cos, sin = math.cos, math.sin
		self.vertices[1].x = self.body:getX() + a * cos(self.body:getAngle()) + b * sin(self.body:getAngle())
		self.vertices[1].y = self.body:getY() - b * cos(self.body:getAngle()) + a * sin(self.body:getAngle())
		self.vertices[2].x = self.body:getX() + a * cos(self.body:getAngle()) - b * sin(self.body:getAngle())
		self.vertices[2].y = self.body:getY() + b * cos(self.body:getAngle()) + a * sin(self.body:getAngle())
		self.vertices[3].x = self.body:getX() - a * cos(self.body:getAngle()) - b * sin(self.body:getAngle())
		self.vertices[3].y = self.body:getY() + b * cos(self.body:getAngle()) - a * sin(self.body:getAngle())
		self.vertices[4].x = self.body:getX() - a * cos(self.body:getAngle()) + b * sin(self.body:getAngle())
		self.vertices[4].y = self.body:getY() - b * cos(self.body:getAngle()) - a * sin(self.body:getAngle())
	end

	if(Body.shapeType == "rectangle") then
		Body.width = arg[3] or 0
		Body.height = arg[4] or 0

		Body.shape = love.physics.newRectangleShape(Body.width, Body.height)
		Body.body:setAngle(math.rad(arg[5] or 0))
		for i=1,4 do Body.vertices[i] = {} end
		Body:updateVertices()
	elseif(Body.shapeType == "circle") then
		Body.radius = arg[3] or 0
		Body.width = Body.radius * 2
		Body.height = Body.width

		Body.shape = love.physics.newCircleShape( arg[3] or 0 )
		Body.body:setAngle(math.rad(arg[4] or 0))
	else return nil end
	Body.fixture = love.physics.newFixture(Body.body, Body.shape)

-- Methods
	--Set methods
	function Body:setCategory( value ) self.fixture:setCategory(value) end
	function Body:setGroup( value ) self.fixture:setGroup(value) end
	function Body:setMask( value ) self.fixture:setMask(value) end
	function Body:setMass( value ) self.body:setMass(value) end
	function Body:setDensity( value ) self.fixture:setDensity(value) end
	function Body:setFriction( value ) self.fixture:setFriction(value) end
	function Body:setRestitution( value ) self.fixture:setRestitution(value) end
	
	function Body:setAngle( value ) self.body:setAngle(math.rad(value)) end

	function Body:setPosition( x, y ) self.body:setX(x); self.body:setY(y) end
	function Body:setX( value ) self.body:setX(value) end
	function Body:setY( value ) self.body:setY(value) end

	function Body:setGroup( name )
		--Remove self from current group
		for i, obj in ipairs(lope.objectsGroup[self.group]) do
			if(obj == self) then
				table.remove(lope.objectsGroup[self.group], i)
			end
		end

		if( lope.objectsGroup[name] == nil ) then
			lope.objectsGroup[name] = {}
		end
		table.insert(lope.objectsGroup[name], self)
		self.group = name
	end

	--Get methods
	function Body:getPosition() return {x = self.body:getX(), y = self.body:getY()} end
	function Body:getX() return self.body:getX() end
	function Body:getY() return self.body:getY() end
	
	function Body:getRadius() if(self.shapeType == "circle") then return self.radius end end

	function Body:getSize() return {x = self.width, y = self.height} end
	function Body:getWidth() return self.width end
	function Body:getHeight() return self.height end

	function Body:getAngle() return self.body:getAngle() end

	function Body:getMass() return self.body:getMass() end
	function Body:getDensity() return self.fixture:getDensity() end
	function Body:getFriction() return self.fixture:getFriction() end
	function Body:getRestitution() return self.fixture:getRestitution() end

	--Graphics
	function Body:setImage( image ) self.image = image end
	function Body:draw( mode ) lope.draw(self, mode or self.image) end

	--Physics
	function Body:applyAngularImpulse( impulse ) self.body:applyAngularImpulse(impulse) end
	function Body:applyForce( fx, fy, ... )
		local arg = {...}
		self.body:applyForce(fx, fy, self.body:getX() + (arg[1] or 0),
		self.body:getY() + (arg[2] or 0))
	end
	function Body:applyLinearImpulse( ix, iy ) self.body:applyLinearImpulse(ix, iy) end
	function Body:applyTorque( torque ) self.body:applyAngularImpulse(torque) end

	function Body:poolProccess( poolX, poolY, poolW )
		if(self.shapeType == "circle") then
			if(self:getY()-self.radius > poolY) then return 0,0 end
			return 0, (self:getY()+self.radius-poolY)/2
		elseif(self.shapeType == "rectangle") then

			local getCross = function(x1,y1,  x2,y2,  x3,y3,  x4,y4)
				local x=((x1*y2-x2*y1)*(x4-x3)-(x3*y4-x4*y3)*(x2-x1))/((y1-y2)*(x4-x3)-(y3-y4)*(x2-x1))
				local y=((y3-y4)*x-(x3*y4-x4*y3))/(x4-x3)
				return -x or -1, y or -1
			end

			local underwaterVtxs = {}
			for i=1,4 do
				if(self.vertices[i].y > poolY) then table.insert(underwaterVtxs, i) end
			end

			local lcmX, lcmY = 0,0
			if(#underwaterVtxs > 0 and #underwaterVtxs < 4) then
				local bottomX, bottomY = 0,0
				local minXY, maxXY = 0,0
				local maxY = self.vertices[underwaterVtxs[1]].y
				local minX = self.vertices[underwaterVtxs[1]].x
				local maxX = self.vertices[underwaterVtxs[1]].x
				local vtxLeft, vtxRight = underwaterVtxs[1], underwaterVtxs[1]

				for i,v in ipairs(underwaterVtxs) do --Bottom vertex
					if(self.vertices[v].y >= maxY) then
						bottomX = self.vertices[v].x
						bottomY = self.vertices[v].y
					end

					if(self.vertices[v].x <= minX) then --Left vertex
						minX = self.vertices[v].x
						minXY = self.vertices[v].y
						vtxLeft = v
					end

					if(self.vertices[v].x >= maxX) then --Right vertex
						maxX = self.vertices[v].x
						maxXY = self.vertices[v].y
						vtxRight = v
					end
				end

				prevVtxLeft = vtxLeft + 1
				if(prevVtxLeft == 5) then prevVtxLeft = 1 end
				nextVtxRight = vtxRight - 1
				if(nextVtxRight == 0) then nextVtxRight = 4 end

				local x1, y1 = getCross(poolX,poolY,  poolX+poolW,poolY, self.vertices[vtxLeft].x,self.vertices[vtxLeft].y,
												  self.vertices[prevVtxLeft].x,self.vertices[prevVtxLeft].y)

				local x2, y2 = getCross(poolX,poolY,  poolX+poolW,poolY, self.vertices[vtxRight].x,self.vertices[vtxRight].y,
												  self.vertices[nextVtxRight].x,self.vertices[nextVtxRight].y)

				lcmX, lcmY = self.body:getLocalPoint(x1 + (x2 - x1)/2, self:getY() + (bottomY - poolY)/2)
			end
			return lcmX, lcmY
		end
	end
--

	table.insert(lope.objectsGroup[Body.group], Body)
	return Body
end

-- newPool( x, y, width, height, [ density ] )
function lope.newPool(x, y, width, height, ...)
	local arg = {...}
	local pool = {
	x = x,
	y = y,
	width = width,
	height = height,
	color = {
			r = 83,
			g = 150,
			b = 181,
			a = 160
		},
	density = arg[1] or 1,
	friction = 0.3,
	groups = {}
	}
	pool.groups[1] = "Default"

-- Methods
	--Set methods
	function pool:setPosition(x, y) self.x = x; self.y = y end
	function pool:setX( value ) self.x = value end
	function pool:setY( value ) self.y = value end

	function pool:setSize( width, height ) self.width = width; self.height = height end
	function pool:setWidth( value ) self.width = value end
	function pool:setHeight( value ) self.height = value end
	
	function pool:setColor( r, g, b, ... ) self.color = {r, g, b, arg[1] or 255} end
	function pool:addGroup( name )
		for _, g in ipairs(self.groups) do
			if(g == name) then return end
		end
		if( lope.objectsGroup[name] == nil ) then
			lope.objectsGroup[name] = {}
		end
		table.insert(self.groups, name)
	end
	function pool:removeGroup( name )
		for i, g in ipairs(self.groups) do
			if(g == name) then
				table.remove(self.groups, i)
				return
			end
		end
	end
	
	--Get methods
	function pool:getPosition() return {x = self.x, y = self.y} end
	function pool:getX() return self.x end
	function pool:getY() return self.y end
	
	function pool:getSize() return {x = self.width, y = self.height} end
	function pool:getWidth() return self.width end
	function pool:getHeight() return self.height end

	function pool:getColor() return {r = self.color.r, g = self.color.g, b = self.color.b, a = self.color.a} end

	--Simulation
	function pool:update( dt )
		for _, group in ipairs(self.groups) do
			for i, object in ipairs(lope.objectsGroup[group]) do
				object:updateVertices()
				if(object:getX() > self.x and object:getX() < self.x + self.width) then
					if(object:getY() + object:getHeight()/2 > self.y and object:getY() + object:getHeight()/2 < self.height + self.y) then
						
						local lcmX, lcmY = object:poolProccess(self.x, self.y, self.width)
						
						local S, hp2 = 0, object:getHeight()/2
						if(object:getY() - object:getHeight()/2 > self.y) then
							S = object:getWidth() * object:getHeight()
						else S = object:getWidth() * ((object:getY() + hp2) - self.y) end

						if(object:getDensity() <= self.density) then
							local Farch = (self.density * WORLD_GRAVITY.y * S) / (object:getHeight()*object:getDensity())
							object:applyForce(0, -Farch, lcmX, lcmY)
						end

						local vx, vy = object.body:getLinearVelocity()
						local fx = self.friction * vx * object:getWidth()
						local fy =  self.friction * vy * object:getWidth()
						if(vy > 0) then object:applyForce(0, -fy, lcmX, lcmY)
						elseif(vy < 0) then object:applyForce(0, fy * self.friction, lcmX, lcmY) end
						object:applyForce( -fx*0.2, 0, lcmX, lcmY)

						local w = object.body:getAngularVelocity()
						object.body:setAngularVelocity(w-w*self.friction * 0.013)
					end
				end
			end
		end
	end

	--Draw
	function pool:draw( ... )
		local arg = {...}
		love.graphics.setColor(self.color.r, self.color.g, self.color.b, self.color.a)
		love.graphics.rectangle(arg[1] or "fill", self.x, self.y, self.width, self.height)
		love.graphics.setColor(255,255,255,255)
	end
--
	return pool
end

-- update( timeDelta )
function lope.update(dt)
	WORLD:update(dt)
end

-- draw( object, [ mode / image ] )
function lope.draw(object, ...)
	local arg = {...}
	if(object.BODY_MARKER == 1) then
		if(arg[1] == "fill" or arg[1] == "line") then
			if(object.shapeType == "rectangle") then
				if(arg[1] == "line") then
					--Draws rects using vertices
					for i=1,3 do
						love.graphics.line(object.vertices[i].x, object.vertices[i].y,
							object.vertices[i+1].x, object.vertices[i+1].y)
					end
					love.graphics.line(object.vertices[4].x, object.vertices[4].y,
						object.vertices[1].x, object.vertices[1].y)
				elseif(arg[1] == "fill") then
					love.graphics.push()
						love.graphics.translate(object:getX(), object:getY())
						love.graphics.rotate(object:getAngle())
						love.graphics.rectangle( "fill", -object.width/2, -object.height/2, object.width, object.height)
					love.graphics.pop()
				end
			elseif(object.shapeType == "circle") then
				love.graphics.circle( arg[1] or "line", object:getX(), object:getY(), object.radius )
				local px, py = object:getX() + object:getRadius() * math.cos(object:getAngle()),
							   object:getY() + object:getRadius() * math.sin(object:getAngle())
				love.graphics.line( object:getX(), object:getY(), px, py )
			end
		else
			if(arg[1] == nil) then object:draw(object.image or "line")
			else
				love.graphics.draw( arg[1] or object.image, object:getX(), object:getY(), object:getAngle(),
									1, 1, object.width/2, object.height/2)
			end
		end
	else
		for _, obj in ipairs(object) do obj:draw(arg[1] or obj.image) end
	end
end