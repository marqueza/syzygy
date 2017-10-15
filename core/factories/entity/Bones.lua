local lovetoys = require "lib.lovetoys.lovetoys"
local function Bones(args)
	entity = lovetoys.Entity()
	entity.name = "Bones"
	if args.x and args.y then
		entity:add(Physics{x=args.x, y=args.y, blocks=false, layer="item", plane=args.plane})
    entity:add(Sprite{filename="img/sprites/bones.png"})
	end
	entity:add(Stack{amount=args.amount})
	return entity
end
return Bones