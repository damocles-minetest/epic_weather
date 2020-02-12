
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

epic.register_hook({
	on_epic_exit = function(playername)
    epic_weather.current_weather[playername] = nil
  end,
	on_epic_abort = function(playername)
    epic_weather.current_weather[playername] = nil
  end
})
