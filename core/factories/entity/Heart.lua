local lovetoys = require "lib.lovetoys.lovetoys"
local function Heart(args)
	entity = lovetoys.Entity()
	entity.name = "Heart"
	if args.x and args.y then
		entity:add(Physics{x=args.x, y=args.y, blocks=false, layer="item", plane=args.plane})
    entity:add(Sprite{filename="img/sprites/heart.png"})
	end
	entity:add(Stack{amount=args.amount})
	return entity
end
return Heart