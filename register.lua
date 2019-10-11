
epic_weather.weatherdefs = {} -- list<weatherdef>

--[[
weatherdef = {
	name = "",
	on_step = function() end
}
--]]

epic_weather.register_weather = function(def)
	table.insert(epic_weather.weatherdefs, def)
end

epic_weather.register_weather({ name = "None" })


