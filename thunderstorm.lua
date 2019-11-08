
epic_weather.register_weather({ name = "Thunderstorm" })


local function do_rain(player)
  local ppos = player:get_pos()
  local player_name = player:get_player_name()

	if math.random(2) == 1 then
		minetest.sound_play("epic_weather_rain", {
			to_player = player_name,
			gain = 1.0,
			fade = 0.5,
			pos = vector.add(ppos, {x=0, y=5, z=0})
		})
	end

  if math.random(10) == 1 then
    local x_offset = math.floor(math.random(100)) - 50
    local y_offset = math.floor(math.random(30))
    local z_offset = math.floor(math.random(100)) - 50

    local strike_pos = vector.add(ppos, { x=x_offset, y=y_offset, z=z_offset})

    lightning.strike(strike_pos)
  end

	minetest.add_particlespawner({
		amount = 750,
		time = 2,
		minpos = vector.add(ppos, {x=-20, y=10, z=-20}),
		maxpos = vector.add(ppos, {x=20, y=10, z=20}),
		minvel = {x=2, y=-5, z=0},
		maxvel = {x=2, y=-12, z=0},
		minacc = {x=0, y=0, z=0},
		maxacc = {x=0, y=0, z=0},
		minexptime = 1,
		maxexptime = 5,
		minsize = 20,
		maxsize = 30.7,
		collisiondetection = true,
		collision_removal = true,
		object_collision = true,
		vertical = true,
		texture = "epic_weather_rain.png",
		playername = player_name
	})
end

local timer = 0
minetest.register_globalstep(function(dtime)
	timer = timer + dtime
	if timer < 2 then return end
	timer=0

  for _, player in ipairs(minetest.get_connected_players()) do
		local playername = player:get_player_name()
		local weathername = epic_weather.current_weather[playername]

    if weathername == "Thunderstorm" then
      do_rain(player)
    end
  end

end)
