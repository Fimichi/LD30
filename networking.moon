export convertToSendable = (a) ->
	planets = {}
	str = "Planet({['name']='#{a.name}',['size']=#{a.size},['colour']={#{a.colour[1]},#{a.colour[2]},#{a.colour[3]}}},{" --the first section
	--entities
	for i=1,#(a.entities)
		adv = string.sub(tostring(a.entities[i].drawableOptions),0,-3).."}"
		str ..= "Entity('#{a.entities[i].object}','#{a.entities[i].imageName}',#{a.entities[i].rad},#{a.entities[i].speed},#{a.entities[i].anim},#{adv})"
		if i<#(a.entities)
			str ..= ","
	str ..= "}"
	--finally add player
	if a.player
		adv = string.sub(tostring(a.player.drawableOptions),0,-3).."}"
		str ..= "Entity('#{a.player.object}','#{a.player.imageName}',#{a.player.rad},#{a.player.speed},#{a.player.anim},#{adv})"
	str ..= ")"
	--export plan = loadstring("return #{str}")()
	str = string.gsub(str," ","_")
	socket.http.request("http://ld30-allhailnoah.rhcloud.com/store/#{str}")
	data = socket.http.request("http://ld30-allhailnoah.rhcloud.com/dump")
	splitData = lume.split(data,"\n")
	for i=1,#splitData
		table.insert(planets,loadstring("return #{splitData[i]}")())
	export currentPlanet = #planets
	return planets