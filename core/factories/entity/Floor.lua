local lovetoys = require "lib.lovetoys.lovetoys"
local function Floor(args)
	entity = lovetoys.Entity()
	entity.name = "floor"
	entity:add(Physics{x=args.x, y=args.y, blocks=false, layer="floor", plane=args.plane})
	entity:add(Sprite{filename="img/sprites/floor.png", color=args.color})
	return entity
end
return Floor
