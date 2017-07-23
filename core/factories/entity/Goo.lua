local lovetoys = require "lib.lovetoys.lovetoys"
local function Goo(args)
	local entity = lovetoys.Entity()
	entity.name = "Goo"
	entity:add(Physics{x=args.x, y=args.y, hp=10, blocks=true})
	entity:add(Sprite{filename="img/sprites/devil.png"})
	entity:add(Faction{name="hostile"})
	return entity
end
return Goo
