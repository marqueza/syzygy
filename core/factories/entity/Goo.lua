local lovetoys = require "lib.lovetoys.lovetoys"
local function Goo(args)
	local entity = lovetoys.Entity()
	entity.name = "Goo"
	entity:add(Physics{x=args.x, y=args.y, hp=10, blocks=true, layer="creature"})
	entity:add(Sprite{filename="img/sprites/goo.png"})
	entity:add(Faction{name="hostile"})
	return entity
end
return Goo
