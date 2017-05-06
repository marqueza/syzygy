local lovetoys = require "lib.lovetoys.lovetoys"
local function Gold(args)
	entity = lovetoys.Entity()
	entity.name = "gold"
	if args.x and args.y then
		entity:add(Physics{x=args.x, y=args.y, hp=1, blocks=true})
	end
	if args.stock then
		entity:add(Stock())
	end
	entity:add(Stack{amount=args.amount})
	return entity
end
return Gold
