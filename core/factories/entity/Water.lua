local lovetoys = require "lib.lovetoys.lovetoys"
local function Water(x, y)
	entity = lovetoys.Entity()
	entity.name = "water"
	entity:add(Physics{x=x, y=y, blocks=true, layer="floor", plane=args.plane})
	entity:add(Sprite{filename="img/sprites/water.png"})
	return entity
end
return Water
