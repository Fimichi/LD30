moon = require"moon"

export convertToSendable = (a) ->
	planets = {}
	str = "Planet({['name']='#{a.name}',['size']=#{a.size},['colour']={#{a.colour[1]},#{a.colour[2]},#{a.colour[3]}}},{" --the first section
	--entities
	for i=1,#(a.entities)
		adv = string.sub(tostring(a.entities[i].drawableOptions),0,-3).."}"
		str ..= "Entity('#{a.entities[i].object}','#{a.entities[i].imageName}',#{a.entities[i].rad},#{a.entities[i].speed},#{a.entities[i].anim},'#{a.entities[i].soundName}',#{adv})"
		if i<#(a.entities)
			str ..= ","
	str ..= "}"
	--finally add player
	if a.player
		adv = string.sub(tostring(a.player.drawableOptions),0,-3).."}"
		str ..= "Entity('#{a.player.object}','#{a.player.imageName}',#{a.player.rad},#{a.player.speed},#{a.player.anim},'#{a.player.sound}',#{adv})"
	str ..= ")"
	--export plan = loadstring("return #{str}")()
	str = string.gsub(str," ","_")
	socket.http.request("http://ld30-allhailnoah.rhcloud.com/store/#{str}")
	data = socket.http.request("http://ld30-allhailnoah.rhcloud.com/dump")
	splitData = lume.split(data,"\n")
	dataCount = 1
	if #splitData>100
		dataCount = #splitData - 100 --only get the last 100 planets
	for i=dataCount,#splitData
		table.insert(planets,loadstring("return #{splitData[i]}")())
	export currentPlanet = #planets
	return planets