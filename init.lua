
local MP = minetest.get_modpath("epic_weather")

epic_weather = {
  current_weather = {}
}

dofile(MP.."/register.lua")
dofile(MP.."/block.lua")
dofile(MP.."/light_rain.lua")
dofile(MP.."/rain.lua")
dofile(MP.."/thunderstorm.lua")
dofile(MP.."/snow.lua")

local has_areas = minetest.get_modpath("areas")
if has_areas then
  dofile(MP.."/areas.lua")
end

local function cleanup(playername)
	local player = minetest.get_player_by_name(playername)
	if player and has_areas then
		-- check if the player was in a weather area
		if epic_weather.get_area_weather(player:get_pos()) then
			-- skip weather disabling
			return
		end
	end
	epic_weather.current_weather[playername] = nil
end

-- epic exit hook, cleanups
epic.register_hook({
  on_epic_exit = cleanup,
	on_epic_abort = cleanup
})
