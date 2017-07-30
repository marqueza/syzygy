local lovetoys = require "lib.lovetoys.lovetoys"
local function CaveFloor(args)
	entity = lovetoys.Entity()
	entity.name = "floor"
	entity:add(Physics{x=args.x, y=args.y, hp=1, blocks=false, layer="floor"})
	entity:add(Sprite{filename="img/sprites/cave_floor.png", color=args.color})
	return entity
end
return CaveFloor