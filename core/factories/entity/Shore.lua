local lovetoys = require "lib.lovetoys.lovetoys"
local function Shore(args)
	entity = lovetoys.Entity()
	entity.name = "shore"
	entity:add(Physics{x=args.x, y=args.y, blocks=true, layer="floor", plane=args.plane, shoreKey=args.shoreKey})
	if args.shoreKey and args.shoreKey~="" then
		entity:add(Sprite{filename="img/sprites/shore_"..args.shoreKey..".png"})
	else
		entity:add(Sprite{filename="img/sprites/shore.png"})
	end
	return entity
end
return Shore
