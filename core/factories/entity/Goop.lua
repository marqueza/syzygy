local lovetoys = require "lib.lovetoys.lovetoys"
local function Goop(args)
	entity = lovetoys.Entity()
	entity.name = "Goop"
	if args.x and args.y then
		entity:add(Physics{x=args.x, y=args.y, blocks=false, layer="item", plane=args.plane})
    entity:add(Sprite{filename="img/sprites/goop.png"})
	end
	entity:add(Stack{amount=args.amount})
	return entity
end
return Goop
