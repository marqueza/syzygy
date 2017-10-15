local lovetoys = require "lib.lovetoys.lovetoys"
local function Dust(args)
	local entity = lovetoys.Entity()
  entity.name = "magic dust"
	entity:add(Physics{x=args.x, y=args.y, blocks=false, layer="item", plane=args.plane})
	entity:add(Sprite{filename="img/sprites/dust.png"})
  entity:add(Stack{amount=args.amount})
	return entity
end
return Dust
