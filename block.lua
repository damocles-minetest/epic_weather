


local update_formspec = function(meta)
	local weathername = meta:get_string("weathername")

	meta:set_string("infotext", "Set weather block: name=" .. weathername)

	local selected = 1
	local list = ""
	for i, def in ipairs(epic_weather.weatherdefs) do
		if def.name == weathername then
			selected = i
		end

		list = list .. minetest.formspec_escape(def.name)
		if i < #epic_weather.weatherdefs then
			-- not end of list
			list = list .. ","
		end
	end

	meta:set_string("formspec", "size[8,6;]" ..
		"textlist[0,0.1;8,5;weathername;" .. list .. ";" .. selected .. "]" ..

		"button_exit[0.1,5.5;8,1;save;Save]" ..
		"")
end

minetest.register_node("epic:set_weather", {
	description = "Epic set weather block",
	tiles = {
		"epic_node_bg.png",
		"epic_node_bg.png",
		"epic_node_bg.png",
		"epic_node_bg.png",
		"epic_node_bg.png",
		"epic_node_bg.png^epic_sky.png",
	},
	paramtype2 = "facedir",
	groups = {cracky=3,oddly_breakable_by_hand=3,epic=1},
	on_rotate = screwdriver.rotate_simple,

	on_construct = function(pos)
    local meta = minetest.get_meta(pos)
		meta:set_string("weathername", "None")
    update_formspec(meta, pos)
  end,

  on_receive_fields = function(pos, _, fields, sender)
		if not sender or minetest.is_protected(pos, sender:get_player_name()) then
			-- not allowed
			return
		end

		local meta = minetest.get_meta(pos);

		if fields.weathername then
			local parts = fields.weathername:split(":")
			if parts[1] == "CHG" then
				local selected_def = tonumber(parts[2])
				local weatherdef = epic_weather.weatherdefs[selected_def]
				if weatherdef and weatherdef.name then
					meta:set_string("weathername", weatherdef.name)
				end
				update_formspec(meta, pos)
			end
		end
  end,

	epic = {
    on_enter = function(_, meta, player, ctx)
			local weathername = meta:get_string("weathername")
			epic_weather.current_weather[player:get_player_name()] = weathername
			ctx.next()
    end
  }
})
