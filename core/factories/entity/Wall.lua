local lovetoys = require "lib.lovetoys.lovetoys"
local function Wall(args)
	entity = lovetoys.Entity()
	entity.name = "wall"
	entity:add(Physics{x=args.x, y=args.y, hp=1, blocks=true})
	entity:add(Sprite{filename="img/sprites/wall.png", color=args.color})
	return entity
end
return Wall
