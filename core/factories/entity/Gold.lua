local lovetoys = require "lib.lovetoys.lovetoys"
local function Gold(args)
	entity = lovetoys.Entity()
	entity.name = "gold"
	if args.x and args.y then
		entity:add(Physics{x=args.x, y=args.y, hp=1, blocks=false, layer="item"})
    entity:add(Sprite{filename="img/sprites/gold.png"})
	end
	entity:add(Stack{amount=args.amount})
	return entity
end
return Gold
