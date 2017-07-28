local lovetoys = require "lib.lovetoys.lovetoys"
local function Cave(args)
	local entity = lovetoys.Entity()
	entity.name = "cave"
	entity:add(Physics{x=args.x, y=args.y, hp=10, blocks=false})
	entity:add(Sprite{filename="img/sprites/mountain.png"})
	entity:add(Entrance{levelName="cave", commandKey=">"})
	return entity
end
return Cave
