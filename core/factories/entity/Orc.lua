local lovetoys = require "lib.lovetoys.lovetoys"
local function Orc(args)
	local entity = lovetoys.Entity()
	entity.name = "orc"
	entity:add(Physics{x=args.x, y=args.y, hp=10, blocks=true})
	entity:add(Sprite{filename="img/sprites/orc.png"})
	entity:add(Faction{name="hostile"})
	return entity
end
return Orc
