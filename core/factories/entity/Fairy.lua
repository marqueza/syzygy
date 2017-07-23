local lovetoys = require "lib.lovetoys.lovetoys"
local function Fairy(args)
	local entity = lovetoys.Entity()
	entity.name = "fairy"
	entity:add(Physics{x=args.x, y=args.y, hp=10, blocks=true})
	entity:add(Sprite{filename="img/sprites/fairy.png"})
	entity:add(Faction{name="hostile"})
	return entity
end
return Fairy
