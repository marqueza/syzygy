local lovetoys = require "lib.lovetoys.lovetoys"
local function Water(args)
	entity = lovetoys.Entity()
	entity.name = "water"
	entity:add(Physics{x=args.x, y=args.y, blocks=true, allowsFov=true, layer="backdrop", plane=args.plane})
	entity:add(Sprite{filename="img/sprites/water.png"})
	return entity
end
return Water
