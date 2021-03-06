local lovetoys = require "lib.lovetoys.lovetoys"
local function Key(args)
	entity = lovetoys.Entity()
	entity.name = "Key"
	if args.x and args.y then
		entity:add(Physics{x=args.x, y=args.y, blocks=false, layer="item", plane=args.plane})
    entity:add(Sprite{filename="img/sprites/key.png"})
	end
	entity:add(Stack{amount=args.amount})
	return entity
end
return Key
