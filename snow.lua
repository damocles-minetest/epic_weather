
epic_weather.register_weather({ name = "Snow" })


local function do_snow(player)
  local ppos = player:get_pos()
  local player_name = player:get_player_name()

  minetest.add_particlespawner({
    amount = 1000,
    time = 5,
    minpos = vector.add(ppos, {x=-20, y=5, z=-20}),
    maxpos = vector.add(ppos, {x=20, y=10, z=20}),
    minvel = {x=0.5, y=-1, z=0},
    maxvel = {x=1, y=-3, z=0},
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
    texture = "epic_weather_snow.png",
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

    if weathername == "Snow" then
      do_snow(player)
    end
  end

end)
