convertToSendable = function(a)
  local planets = { }
  local name = string.gsub(a.name, "'", "\\'")
  local str = "Planet({['name']='" .. tostring(name) .. "',['size']=" .. tostring(a.size) .. ",['colour']={" .. tostring(a.colour[1]) .. "," .. tostring(a.colour[2]) .. "," .. tostring(a.colour[3]) .. "}},{"
  for i = 1, #(a.entities) do
    local adv = string.sub(tostring(a.entities[i].drawableOptions), 0, -3) .. "}"
    str = str .. "Entity('" .. tostring(a.entities[i].object) .. "','" .. tostring(a.entities[i].imageName) .. "'," .. tostring(a.entities[i].rad) .. "," .. tostring(a.entities[i].speed) .. "," .. tostring(a.entities[i].anim) .. ",'" .. tostring(a.entities[i].soundName) .. "'," .. tostring(adv) .. ")"
    if i < #(a.entities) then
      str = str .. ","
    end
  end
  str = str .. "}"
  if a.player then
    local adv = string.sub(tostring(a.player.drawableOptions), 0, -3) .. "}"
    str = str .. "Entity('" .. tostring(a.player.object) .. "','" .. tostring(a.player.imageName) .. "'," .. tostring(a.player.rad) .. "," .. tostring(a.player.speed) .. "," .. tostring(a.player.anim) .. ",'" .. tostring(a.player.sound) .. "'," .. tostring(adv) .. ")"
  end
  str = str .. ")"
  str = string.gsub(str, " ", "_")
  socket.http.request("http://ld30-allhailnoah.rhcloud.com/store/" .. tostring(str))
  local data = socket.http.request("http://ld30-allhailnoah.rhcloud.com/dump")
  local splitData = lume.split(data, "\n")
  local dataCount = 1
  if #splitData > 100 then
    dataCount = #splitData - 100
  end
  for i = dataCount, #splitData do
    print(loadstring("return " .. tostring(splitData[i])))
    table.insert(planets, loadstring("return " .. tostring(splitData[i]))())
  end
  currentPlanet = #planets
  return planets
end
