local lovetoys = require "lib.lovetoys.lovetoys"
local function Stone(args)
	entity = lovetoys.Entity()
	entity.name = "Stone"
	if args.x and args.y then
		entity:add(Physics{x=args.x, y=args.y, hp=1, blocks=false, layer="item", plane=args.plane})
    entity:add(Sprite{filename="img/sprites/stone.png"})
	end
	entity:add(Stack{amount=args.amount or 1})
	return entity
end
return Stone
