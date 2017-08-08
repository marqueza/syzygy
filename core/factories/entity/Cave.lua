local lovetoys = require "lib.lovetoys.lovetoys"
local function Cave(args)
	local entity = lovetoys.Entity()
	entity.name = "cave"
	entity:add(Physics{x=args.x, y=args.y, hp=10, blocks=false, layer="backdrop", plane=args.plane})
	entity:add(Sprite{filename="img/sprites/mountain.png"})
	entity:add(Entrance{levelName="cave"..math.floor(math.random()*10000), commandKey=">"})
	return entity
end
return Cave
