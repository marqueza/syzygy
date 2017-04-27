local lovetoys = require "lib.lovetoys.lovetoys"
local function Cave(x, y)
	local entity = lovetoys.Entity()
	entity.name = "cave"
	entity:add(Physics{x=x, y=y, hp=10, blocks=false})
	entity:add(Sprite{filename="img/sprites/mountain.png"})
	entity:add(Entrance{levelName="2-1", commandKey=">"})
	return entity
end
return Cave
