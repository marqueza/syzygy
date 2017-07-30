local lovetoys = require "lib.lovetoys.lovetoys"
local function Medal(args)
	local entity = lovetoys.Entity()
	entity.name = "small medal"
	entity:add(Physics{x=args.x, y=args.y, hp=1, blocks=false, layer="item"})
	entity:add(Sprite{filename="img/sprites/medal.png"})
	return entity
end
return Medal
