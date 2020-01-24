
-- id => WeatherName
local weather_areas = {}

-- api
function epic_weather.get_area_weather(pos)
  local area_list = areas:getAreasAtPos(pos)
  for id in pairs(area_list) do
    local weather_name = weather_areas[id]
    if weather_name and weather_name ~= "" then
      return weather_name
    end
  end
end

-- players handled by area weather
local handled_by_area_weather = {}

-- cleanup
minetest.register_on_leaveplayer(function(player)
	local playername = player:get_player_name()
	handled_by_area_weather[playername] = nil
end)

-- globalstep
local timer = 0
minetest.register_globalstep(function(dtime)
	timer = timer + dtime
	if timer < 2 then return end
	timer=0

  for _, player in ipairs(minetest.get_connected_players()) do
		local playername = player:get_player_name()
		local weathername = epic_weather.current_weather[playername]

    if weathername and weathername ~= "" then
      -- check weather area
      local area_weather = epic_weather.get_area_weather(player:get_pos())

      if area_weather then
        -- set weather
        epic_weather.current_weather[playername] = area_weather
        handled_by_area_weather[playername] = true

      elseif handled_by_area_weather[playername] then
        -- remove weather if it was set by weather area
        epic_weather.current_weather[playername] = nil
        handled_by_area_weather[playername] = nil

      end
    end
  end

end)


-- File writing / reading utilities

local wpath = minetest.get_worldpath()
local filename = wpath.."/weather_areas.dat"

local function load_weather_areas()
	local f = io.open(filename, "r")
	if f == nil then return {} end
	local t = f:read("*all")
	f:close()
	if t == "" or t == nil then return {} end
	return minetest.deserialize(t)
end

local function save_weather_areas()
	local f = io.open(filename, "w")
	f:write(minetest.serialize(weather_areas))
	f:close()
end

weather_areas = load_weather_areas()


-- chat

minetest.register_chatcommand("weather_set_area", {
    params = "<ID> <Weather Name>",
    description = "Set or clear weather of an area",
    func = function(playername, param)
      local _, _, id_str, weather_name = string.find(param, "^([^%s]+)%s+([^%s]+)%s*$")
      if id_str == nil then
        return true, "Invalid syntax!"
      end

      local id = tonumber(id_str)
      if not id then
        return true, "area-id is not numeric: " .. id_str
      end

      if not areas:isAreaOwner(id, playername) and
        not minetest.check_player_privs(playername, { protection_bypas=true }) then
        return true, "you are not the owner of area: " .. id
      end

      weather_areas[id] = weather_name
      save_weather_areas()
			return true, "Area " .. id .. " Weather: " .. (weather_name or "<none>")
    end,
})
