local lovetoys = require "lib.lovetoys.lovetoys"
local function Grass(args)
	entity = lovetoys.Entity()
	entity.name = "grass"
	entity:add(Physics{x=args.x, y=args.y, hp=1, blocks=false, layer="floor"})
	entity:add(Sprite{filename="img/sprites/grass.png"})
	return entity
end
return Grass
