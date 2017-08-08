local lovetoys = require "lib.lovetoys.lovetoys"
local function Golem(args)
	local entity = lovetoys.Entity()
	entity.name = "Golem"
	entity:add(Physics{x=args.x, y=args.y, hp=10, blocks=true, plane=args.plane})
	entity:add(Sprite{filename="img/sprites/golem.png"})
	entity:add(Faction{name="hostile"})
	return entity
end
return Golem
