local lovetoys = require "lib.lovetoys.lovetoys"
local function Wood(args)
	entity = lovetoys.Entity()
	entity.name = "Wood"
	if args.x and args.y then
		entity:add(Physics{x=args.x, y=args.y, hp=1, blocks=false, layer="item", plane=args.plane})
    entity:add(Sprite{filename="img/sprites/wood.png"})
	end
	entity:add(Stack{amount=args.amount or 5})
	return entity
end
return Wood
