local lovetoys = require "lib.lovetoys.lovetoys"
local function Shore(args)
	entity = lovetoys.Entity()
	entity.name = "shore"
	entity:add(Physics{x=args.x, y=args.y, hp=1, blocks=true})
	if args.isCorner then
		entity:add(Sprite{filename="img/sprites/shore_corner.png", direction=args.direction})
	else
		entity:add(Sprite{filename="img/sprites/shore.png", direction=args.direction})
	end
	return entity
end
return Shore
