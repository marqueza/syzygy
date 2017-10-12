local lovetoys = require "lib.lovetoys.lovetoys"
local function Grass(args)
	entity = lovetoys.Entity()
	entity.name = "grass"
	entity:add(Physics{x=args.x, y=args.y, blocks=false, layer="floor", plane=args.plane})
	entity:add(Sprite{filename="img/sprites/grass.png"})
	return entity
end
return Grass
